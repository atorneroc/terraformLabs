location = "East US"

tags = {
  owner       = "atorneroc"
  project     = "nsf"
  environment = "dev"
}

resource_group_name = "rg-nsf-dev"

vnet_name       = "vnet-nsf-dev"
vnet_cidr       = "10.10.0.0/16"
aks_subnet_name = "snet-aks"
aks_subnet_cidr = "10.10.1.0/24"

aks_name           = "aks-nsf-dev"
aks_dns_prefix     = "aks-nsf-dev"
kubernetes_version = "1.33.5"
node_vm_size       = "Standard_D2ds_v5"
node_count         = 1

apim_name            = "apim-nsf-dev"
apim_publisher_name  = "ATC"
apim_publisher_email = "atc@test.com"
apim_sku_name        = "Developer_1"

pg_name                  = "pgflex-nsf-dev-tf"
pg_admin_login           = "pgadmin"
pg_admin_password        = "ChangeM3Now!"   # en real lo moverías a variable de entorno / Key Vault
pg_sku_name              = "GP_Standard_D2ds_v5"
pg_storage_mb            = 32768
pg_version               = "16"
pg_ha_enabled            = false
pg_zone                  = "1"

func_billing_name         = "func-nsf-dev-billing-tf"
func_billing_storage_name = "stnsfdevfuncbilltf"   # minúsculas, <= 24 chars, único global

func_util_name            = "func-nsf-dev-util-tf"
func_util_storage_name    = "stnsfdevfuncutiltf"

func_reports_name         = "func-nsf-dev-reports-tf"
func_reports_storage_name = "stnsfdevfuncreportstf"

# subscription_id = "86462eaa-68cf-4d00-bac6-cd07b1968a49"
# tenant_id       = "d3acff10-5531-465c-b3fd-9186f2fab5cf"