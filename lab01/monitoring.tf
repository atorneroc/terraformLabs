###############################################################################
# 📊 MÓDULO 2.3 — Observabilidad y Monitoreo
# Conecta tu App Service con Application Insights y crea alertas de métricas
###############################################################################

###############################################################################
# 1️⃣ Application Insights
###############################################################################
resource "azurerm_application_insights" "app_insights" {
  name                = "appi-${var.environment}-${var.app_service_name}"
  location            = azurerm_resource_group.rg_main.location
  resource_group_name = azurerm_resource_group.rg_main.name
  application_type    = "web"

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}


###############################################################################
# 3️⃣ Action Group — Notificación de alertas
###############################################################################
resource "azurerm_monitor_action_group" "alert_group" {
  name                = "ag-${var.environment}-notificaciones"
  resource_group_name = azurerm_resource_group.rg_main.name
  short_name          = "alerts"

  email_receiver {
    name                    = "correo_alertas"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  tags = {
    environment = var.environment
    owner       = var.owner
  }
}

###############################################################################
# 4️⃣ Alerta por CPU alta en App Service
###############################################################################
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "alerta-cpu-${var.environment}"
  resource_group_name = azurerm_resource_group.rg_main.name
  scopes              = [azurerm_service_plan.asp_main.id]
  description         = "Alerta cuando el uso de CPU supera el 80% durante 5 minutos"

  criteria {
    metric_namespace = "Microsoft.Web/serverFarms"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.alert_cpu_threshold
  }

  window_size   = "PT5M"
  frequency     = "PT1M"
  severity      = 2
  auto_mitigate = true
  action {
    action_group_id = azurerm_monitor_action_group.alert_group.id
  }

  tags = {
    environment = var.environment
    owner       = var.owner
  }
}
