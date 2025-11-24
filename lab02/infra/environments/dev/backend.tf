terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"        # cámbialo a tu RG de state
    storage_account_name = "scharfftstate"     # cámbialo a tu storage
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}
