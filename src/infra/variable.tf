variable "aws_region" {
  type     = string
  nullable = false
}

variable "project_name" {
  type     = string
  nullable = false
  default  = "serverless-demo"
}

variable "project_environment" {
  type     = string
  nullable = false
}

# Random Length
variable "random_pet_length" {
  type    = number
  default = 1
}

# cloudfront
variable "domain_name" {
  description = "Domain name for the website (optional)"
  type        = string
  nullable    = false
  default     = ""
}


# dynamodb
variable "dynamodb_table_billing_mode" {
  type     = string
  nullable = false
  default  = "PAY_PER_REQUEST"
}

variable "dynamodb_table_hash_key" {
  type     = string
  nullable = false
  default  = "Id"
}

variable "dynamodb_table_attribute_name" {
  type     = string
  nullable = false
  default  = "Id"
}

variable "dynamodb_table_attribute_type" {
  type     = string
  nullable = false
  default  = "S"
}

# Template parameters
variable "tpl_params" {
  type = map(string)
  default = {
    # Basic shop info
    shop_name        = "Nome Negozio Esempio"
    current_year     = "2025"
    rights_reserved  = "Tutti i diritti riservati"
    welcome_message  = "Benvenuti nel nostro negozio!"
    shop_description = "Il miglior negozio locale per tutti i vostri bisogni"

    # Navigation and buttons
    view_products = "Visualizza Prodotti"
    contact_us    = "Contattaci"

    # Features section
    feature_1_title = "Qualità Premium"
    feature_1_desc  = "Offriamo solo prodotti della migliore qualità"
    feature_2_title = "Servizio Clienti"
    feature_2_desc  = "Il nostro team è sempre pronto ad aiutarvi"
    feature_3_title = "Consegna Rapida"
    feature_3_desc  = "Consegniamo i vostri ordini in tempi record"

    # Contact section
    contact_title = "Contattaci"
    address_label = "Indirizzo"
    phone_label   = "Telefono"
    email_label   = "Email"
    hours_label   = "Orari"
    shop_address  = "Via Roma 123, Milano, Italia"
    shop_phone    = "+39 02 1234567"
    shop_email    = "info@negozioesempio.it"
    shop_hours    = "Lun-Ven 9:00-18:00, Sab 9:00-13:00"

    # Products page
    products_title         = "I Nostri Prodotti"
    products_subtitle      = "Scopri la nostra selezione di prodotti di qualità"
    loading_text           = "Caricamento prodotti..."
    error_loading_products = "Errore nel caricamento dei prodotti"
    retry_text             = "Riprova"
    no_products_found      = "Nessun prodotto trovato"
    currency_symbol        = "€"
    add_to_cart_text       = "Aggiungi al Carrello"
    network_error          = "Errore di rete"

    # Add product page
    add_product_title               = "Aggiungi Nuovo Prodotto"
    add_product_subtitle            = "Inserisci i dettagli del nuovo prodotto"
    product_name_label              = "Nome Prodotto"
    product_name_placeholder        = "Inserisci il nome del prodotto"
    product_description_label       = "Descrizione"
    product_description_placeholder = "Descrivi il prodotto"
    product_price_label             = "Prezzo"
    product_stock_label             = "Quantità"
    product_category_label          = "Categoria"
    select_category                 = "Seleziona categoria"
    category_1                      = "Elettronica"
    category_2                      = "Abbigliamento"
    category_3                      = "Casa e Giardino"
    category_4                      = "Sport e Tempo Libero"
    product_sku_label               = "Codice SKU"
    product_sku_placeholder         = "Codice prodotto (generato automaticamente)"
    product_image_label             = "URL Immagine"
    product_image_placeholder       = "https://esempio.com/immagine.jpg"
    product_tags_label              = "Tag"
    product_tags_placeholder        = "tag1, tag2, tag3"
    tags_help_text                  = "Separa i tag con virgole"
    reset_form_text                 = "Resetta"
    add_product_button              = "Aggiungi Prodotto"
    product_added_success           = "Prodotto aggiunto con successo!"
    add_another_text                = "Aggiungi Altro"
    view_products_text              = "Visualizza Prodotti"
    error_adding_product            = "Errore nell'aggiunta del prodotto"
    try_again_text                  = "Riprova"
    adding_product_text             = "Aggiungendo..."

    # Advanced products page
    advanced_products_title    = "Gestione Prodotti Avanzata"
    advanced_products_subtitle = "Visualizza e gestisci tutti i prodotti"
    category_label             = "Categoria"
    all_categories             = "Tutte le categorie"
    price_range_label          = "Fascia di prezzo"
    all_prices                 = "Tutti i prezzi"
    price_range_1              = "€0 - €50"
    price_range_2              = "€50 - €100"
    price_range_3              = "€100+"
    search_label               = "Cerca"
    search_placeholder         = "Cerca prodotti..."
    product_name_header        = "Nome"
    category_header            = "Categoria"
    price_header               = "Prezzo"
    stock_header               = "Scorte"
    actions_header             = "Azioni"
    view_text                  = "Visualizza"
    edit_text                  = "Modifica"
    view_product_message       = "Visualizza prodotto"
    edit_product_message       = "Modifica prodotto"
  }
}

# Lambda

variable "lambda_products_get_timeout" {
  type    = number
  default = 30
}

variable "lambda_products_post_timeout" {
  type    = number
  default = 30
}



# Lambda Function URL - Post Products

variable "lambda_function_url_post_cors_enable" {
  type    = bool
  default = false
}

variable "lambda_function_url_post_cors_allow_credentials" {
  type    = bool
  default = false
}

variable "lambda_function_url_post_cors_allow_headers" {
  type    = list(string)
  default = ["*"]
}

variable "lambda_function_url_post_cors_allow_methods" {
  type    = list(string)
  default = ["POST"]
}

variable "lambda_function_url_post_cors_allow_origins" {
  type    = list(string)
  default = ["*"]
}

variable "lambda_function_url_post_cors_expose_headers" {
  type    = list(string)
  default = ["*"]
}

variable "lambda_function_url_post_cors_max_age" {
  type    = number
  default = 0
}

# Lambda Function URL - Get Products

variable "lambda_function_url_get_cors_enable" {
  type    = bool
  default = false
}

variable "lambda_function_url_get_cors_allow_credentials" {
  type    = bool
  default = false
}

variable "lambda_function_url_get_cors_allow_headers" {
  type    = list(string)
  default = ["*"]
}

variable "lambda_function_url_get_cors_allow_methods" {
  type    = list(string)
  default = ["GET"]
}

variable "lambda_function_url_get_cors_allow_origins" {
  type    = list(string)
  default = ["*"]
}

variable "lambda_function_url_get_cors_expose_headers" {
  type    = list(string)
  default = ["*"]
}

variable "lambda_function_url_get_cors_max_age" {
  type    = number
  default = 0
}
