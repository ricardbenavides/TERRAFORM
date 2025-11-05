terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.35.0"
    }
  }
}
# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}
  subscription_id = "db2a32a5-cc0d-4c57-8552-ce294939a17f"

}
