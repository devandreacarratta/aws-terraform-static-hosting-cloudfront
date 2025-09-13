import json
import boto3
import os
import uuid
from datetime import datetime, timezone
from decimal import Decimal
import logging
import re

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Environment variables
DYNAMODB_TABLE = os.getenv("DYNAMODB_TABLE", "products")

# Initialize DynamoDB resource
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(DYNAMODB_TABLE)

# Removed category validation as requested


def convert_floats(obj):
    """Convert float values to Decimal for DynamoDB storage"""
    if isinstance(obj, float):
        return Decimal(str(obj)) 
    elif isinstance(obj, dict):
        return {k: convert_floats(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [convert_floats(v) for v in obj]
    return obj


def validate_product_data(product_data):
    """Validate required fields and data types for product creation"""
    errors = []
    
    # Required fields (removed category validation as requested)
    required_fields = ["name", "price", "stock"]
    for field in required_fields:
        if field not in product_data or not product_data[field]:
            errors.append(f"Missing required field: {field}")
    
    # Validate name
    if "name" in product_data:
        if not isinstance(product_data["name"], str) or len(product_data["name"].strip()) < 2:
            errors.append("Product name must be at least 2 characters long")
    
    # Validate price
    if "price" in product_data:
        try:
            price = float(product_data["price"])
            if price < 0:
                errors.append("Price must be a positive number")
        except (ValueError, TypeError):
            errors.append("Price must be a valid number")
    
    # Validate stock
    if "stock" in product_data:
        try:
            stock = int(product_data["stock"])
            if stock < 0:
                errors.append("Stock must be a non-negative integer")
        except (ValueError, TypeError):
            errors.append("Stock must be a valid integer")
    
    # Validate image URL if provided
    if "image" in product_data and product_data["image"]:
        url_pattern = re.compile(
            r'^https?://'  # http:// or https://
            r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+[A-Z]{2,6}\.?|'  # domain...
            r'localhost|'  # localhost...
            r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'  # ...or ip
            r'(?::\d+)?'  # optional port
            r'(?:/?|[/?]\S+)$', re.IGNORECASE)
        if not url_pattern.match(product_data["image"]):
            errors.append("Image must be a valid URL")
    
    return errors


def generate_sku(name, category=None):
    """Generate a SKU based on category and product name"""
    # Get category code (first 3 letters, default to PRO if no category)
    if category:
        category_code = category[:3].upper()
    else:
        category_code = "PRO"
    
    # Get name code (first 3 letters of first word)
    name_words = name.strip().split()
    name_code = name_words[0][:3].upper() if name_words else "ITM"
    
    # Generate random number
    import random
    random_num = f"{random.randint(1, 999):03d}"
    
    return f"{category_code}-{name_code}-{random_num}"


def format_product_for_storage(product_data):
    """Format and clean product data for DynamoDB storage"""
    # Generate unique ID
    product_id = str(uuid.uuid4())
    
    # Create the product item (using 'Id' with capital I for DynamoDB key)
    product = {
        "Id": product_id,  # DynamoDB primary key (capital I)
        "name": product_data["name"].strip(),
        "description": product_data.get("description", "").strip(),
        "price": float(product_data["price"]),
        "stock": int(product_data["stock"]),
        "category": product_data.get("category", "").strip(),
        "sku": product_data.get("sku", "").strip() or generate_sku(product_data["name"], product_data.get("category")),
        "image": product_data.get("image", "").strip() or "/images/placeholder.png",
        "tags": product_data.get("tags", []) if isinstance(product_data.get("tags"), list) else [],
        "createdAt": datetime.now(timezone.utc).isoformat(),
        "updatedAt": datetime.now(timezone.utc).isoformat()
    }
    
    return product


def get_cors_headers():
    """Get comprehensive CORS headers for all responses"""
    # Allow environment-specific CORS configuration
    allowed_origins = os.getenv("ALLOWED_ORIGINS", "*")
    
    return {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": allowed_origins,
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, X-Amz-Date, Authorization, X-Api-Key, X-Amz-Security-Token, X-Amz-User-Agent",
        "Access-Control-Allow-Credentials": "false",
        "Access-Control-Max-Age": "86400"
    }


def lambda_handler(event, context):
    """
    Lambda function to create products in DynamoDB
    Expects JSON body with either a single product or an array of products
    """
    try:
        logger.info(f"Received event: {json.dumps(event)}")
        
        # Handle health check
        if event.get("path") == "/health":
            return {
                "statusCode": 200,
                "headers": get_cors_headers(),
                "body": json.dumps({
                    "status": "healthy",
                    "service": "post-products",
                    "timestamp": datetime.now(timezone.utc).isoformat()
                })
            }
        
        # Handle preflight OPTIONS request
        http_method = event.get("requestContext", {}).get("http", {}).get("method")
        if http_method == "OPTIONS":
            logger.info("Handling preflight OPTIONS request")
            return {
                "statusCode": 200,
                "headers": get_cors_headers(),
                "body": ""
            }
        
        # Check if this is a POST request (for API Gateway)
        if http_method and http_method != "POST":
            logger.error(f"Method not allowed: {http_method}")
            return {
                "statusCode": 405,
                "headers": get_cors_headers(),
                "body": json.dumps({
                    "message": f"Method Not Allowed. Expected: POST, Received: {http_method}"
                })
            }

        # Check if body exists
        if "body" not in event or not event["body"]:
            logger.error("Request body is missing")
            return {
                "statusCode": 400,
                "headers": get_cors_headers(),
                "body": json.dumps({"message": "Request body is required"})
            }

        # Parse JSON body
        try:
            request_data = json.loads(event["body"])
        except json.JSONDecodeError as e:
            logger.error(f"Invalid JSON in request body: {str(e)}")
            return {
                "statusCode": 400,
                "headers": get_cors_headers(),
                "body": json.dumps({
                    "message": "Invalid JSON format in request body",
                    "error": str(e)
                })
            }

        # Handle both single product and array of products
        if isinstance(request_data, list):
            products_data = request_data
            logger.info(f"Processing array of {len(products_data)} products")
        elif isinstance(request_data, dict):
            products_data = [request_data]
            logger.info("Processing single product")
        else:
            return {
                "statusCode": 400,
                "headers": get_cors_headers(),
                "body": json.dumps({
                    "message": "Request body must be a product object or array of products"
                })
            }

        # Validate and process each product
        created_products = []
        validation_errors = []
        
        for index, product_data in enumerate(products_data):
            # Validate product data
            errors = validate_product_data(product_data)
            if errors:
                validation_errors.append({
                    "index": index,
                    "errors": errors,
                    "product": product_data.get("name", f"Product {index + 1}")
                })
                continue
            
            try:
                # Format product for storage
                product = format_product_for_storage(product_data)
                
                # Convert floats to Decimal for DynamoDB
                product = convert_floats(product)
                
                logger.info(f"Saving product {index + 1} with ID: {product['Id']}")
                
                # Save to DynamoDB
                table.put_item(Item=product)
                
                created_products.append({
                    "productId": product["Id"],
                    "name": product["name"],
                    "sku": product["sku"]
                })
                
                logger.info(f"Product {index + 1} saved successfully: {product['Id']}")
                
            except Exception as e:
                logger.error(f"Error saving product {index + 1}: {str(e)}")
                validation_errors.append({
                    "index": index,
                    "errors": [f"Failed to save product: {str(e)}"],
                    "product": product_data.get("name", f"Product {index + 1}")
                })

        # Prepare response
        response_data = {
            "message": f"Processed {len(products_data)} products",
            "created": len(created_products),
            "failed": len(validation_errors),
            "createdProducts": created_products
        }
        
        if validation_errors:
            response_data["errors"] = validation_errors
        
        # Determine status code
        if len(created_products) == 0:
            # All products failed
            status_code = 400
            response_data["message"] = "All products failed validation or creation"
        elif len(validation_errors) == 0:
            # All products succeeded
            status_code = 201
            response_data["message"] = f"Successfully created {len(created_products)} products"
        else:
            # Partial success
            status_code = 207  # Multi-Status
            response_data["message"] = f"Partially successful: {len(created_products)} created, {len(validation_errors)} failed"
        
        logger.info(f"Operation completed: {len(created_products)} created, {len(validation_errors)} failed")
        
        return {
            "statusCode": status_code,
            "headers": get_cors_headers(),
            "body": json.dumps(response_data)
        }

    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        return {
            "statusCode": 500,
            "headers": get_cors_headers(),
            "body": json.dumps({
                "message": "Internal Server Error", 
                "error": str(e)
            })
        }