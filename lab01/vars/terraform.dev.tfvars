# ======================================================
# 🌱 Entorno DEV – Infraestructura real Azure
# ======================================================
location             = "eastus"
resource_group_name  = "rg-terraform-lab-dev"
storage_account_name = "stterraformdevatornero"
blob_container_name  = "container-dev"
owner                = "alfredo.tornero@scharff.com.pe"
environment          = "dev"

# --- Módulo 2 — Variables para ACR, App Service y Key Vault ---
acr_name              = "acrnsfdevatornero"
app_service_plan_name = "asp-nsf-dev"
app_service_name      = "app-nsf-dev"
key_vault_name        = "kv-nsf-dev-atornero"

# 🔐 Valor sensible del Key Vault (solo en entorno dev)
api_secret_value      = "12345-TEST-KEY"