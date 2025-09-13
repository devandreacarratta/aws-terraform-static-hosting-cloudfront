import json
import boto3
import os
import logging
from datetime import datetime, timezone
from decimal import Decimal

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Environment variables
DYNAMODB_TABLE = os.getenv("DYNAMODB_TABLE", "products")

# Initialize DynamoDB resource
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(DYNAMODB_TABLE)


def convert_decimals(obj):
    """Convert DynamoDB Decimal types to float for JSON serialization"""
    if isinstance(obj, Decimal):
        return float(obj) 
    elif isinstance(obj, dict):
        return {k: convert_decimals(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [convert_decimals(v) for v in obj]
    return obj


def format_product(item):
    """Format DynamoDB item to match the expected product JSON structure"""
    # Convert decimals first
    item = convert_decimals(item)
    
    # Map DynamoDB fields to expected JSON format
    product = {
        "id": str(item.get("id", item.get("Id", ""))),
        "name": item.get("name", ""),
        "description": item.get("description", ""),
        "price": item.get("price", 0.0),
        "stock": int(item.get("stock", 0)),
        "category": item.get("category", ""),
        "sku": item.get("sku", ""),
        "image": item.get("image", "/images/placeholder.png"),
        "tags": item.get("tags", [])
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
    Lambda function to get all products from DynamoDB
    Returns JSON array of products matching the web-template/products.json format
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
                    "service": "get-products",
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
        
        # Check if this is a GET request (for API Gateway)
        if http_method and http_method != "GET":
            logger.error(f"Method not allowed: {http_method}")
            return {
                "statusCode": 405,
                "headers": get_cors_headers(),
                "body": json.dumps({
                    "message": f"Method Not Allowed. Expected: GET, Received: {http_method}"
                })
            }

        # Scan the entire table to get all products
        logger.info("Scanning DynamoDB table for all products")
        
        response = table.scan()
        items = response.get("Items", [])
        
        # Handle pagination if there are more items
        while "LastEvaluatedKey" in response:
            logger.info("Fetching additional items from DynamoDB")
            response = table.scan(ExclusiveStartKey=response["LastEvaluatedKey"])
            items.extend(response.get("Items", []))
        
        logger.info(f"Retrieved {len(items)} products from DynamoDB")
        
        # Format products to match the expected JSON structure
        products = [format_product(item) for item in items]
        
        # Sort products by ID for consistent ordering
        products.sort(key=lambda x: x["id"])
        
        logger.info(f"Returning {len(products)} formatted products")
        
        return {
            "statusCode": 200,
            "headers": get_cors_headers(),
            "body": json.dumps(products)
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