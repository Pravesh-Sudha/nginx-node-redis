provider "aws" {
  region                      = var.region
  skip_credentials_validation = true  # Safe for dev/CI (as discussed)
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  default_tags {
    tags = {
      Environment = var.env_name
      Project     = var.app_name
    }
  }
}