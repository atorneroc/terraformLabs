resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_service_plan" "this" {
  name                = "${var.func_name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.plan_sku_name
  tags                = var.tags
}

resource "azurerm_linux_function_app" "this" {
  name                = var.func_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id

  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = true
    }
    ftps_state = "Disabled"
  }

  app_settings = merge({
    FUNCTIONS_EXTENSION_VERSION = "~4"
    AzureWebJobsStorage         = azurerm_storage_account.this.primary_connection_string
    WEBSITE_RUN_FROM_PACKAGE    = "1"
  }, var.app_settings)

  tags = var.tags
}
