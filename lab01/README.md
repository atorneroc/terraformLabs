# 🏗️ Terraform Lab 01 — ACR → App Service Integration

Este laboratorio despliega un entorno completo en **Azure** utilizando **Terraform**, configurando la conexión entre un **Azure Container Registry (ACR)** y un **App Service** con autenticación mediante **Managed Identity**.

---

## 📁 Estructura inicial

1. Crear los siguientes archivos en tu proyecto:
   - `main.tf`
   - `outputs.tf`
   - `provider.tf`
   - `variables.tf`

   - `backend/backend.dev.tfvars`
   - `backend/backend.qa.tfvars`

   - `vars/terraform.dev.tfvars`
   - `vars/terraform.qa.tfvars`

---

## ☁️ Crear manualmente los recursos base en Azure

### 1️⃣ Grupo de recursos del backend
az group create -n rg-tfstate -l eastus

### 2️⃣ Storage account único global (usa minúsculas y sin guiones)
az storage account create \
  -n scharfftstate \
  -g rg-tfstate \
  -l eastus \
  --sku Standard_LRS

### 3️⃣ Contenedor para los estados
az storage container create \
  -n tfstate \
  --account-name scharfftstate

# ⚙️ Inicialización y Validación de Terraform
## Inicializa el proyecto Terraform (descarga proveedores, módulos y configura el backend)
terraform init -reconfigure -backend-config="backend/backend.dev.tfvars"

## Formatea los archivos .tf según el estilo oficial de HashiCorp
terraform fmt

## Valida la sintaxis y estructura de los archivos
terraform validate

## Genera el plan de ejecución
terraform plan -var-file="vars/terraform.dev.tfvars"

# 🚀 Aplicar Cambios
## Si todo está correcto en el plan:
terraform apply -var-file="vars/terraform.dev.tfvars" -auto-approve
## 📘 Nota: En entornos productivos no se recomienda usar -auto-approve para evitar aplicar cambios sin revisión manual.

# 🧹 Destruir Recursos y eliminar todos los recursos creados:
terraform init -reconfigure -backend-config="backend/backend.dev.tfvars"
terraform destroy -var-file="vars/terraform.dev.tfvars" -auto-approve

# 🧩 Comandos esenciales de validación y depuración
## 1️⃣ Verificar configuración del contenedor
az webapp config container show --name app-nsf-dev --resource-group rg-terraform-lab-dev

## 2️⃣ Verificar logs en vivo del App Service
az webapp log tail --name app-nsf-dev --resource-group rg-terraform-lab-dev

## 3️⃣ Obtener el principalId (identidad del App Service)
az webapp identity show --name app-nsf-dev --resource-group rg-terraform-lab-dev

## 4️⃣ Validar el rol AcrPull asignado
az role assignment list --all \
  --assignee $(az webapp identity show --name app-nsf-dev --resource-group rg-terraform-lab-dev --query principalId -o tsv) \
  --output table

## 5️⃣ Verificar que la autenticación con identidad esté activa
az webapp show --name app-nsf-dev --resource-group rg-terraform-lab-dev --query "siteConfig.acrUseManagedIdentityCreds"

## 6️⃣ Confirmar que la imagen configurada coincide con la subida al ACR
az acr repository show-tags --name acrnsfdevatornero --repository nginx -o table

## 7️⃣ Reiniciar el App Service
az webapp restart --name app-nsf-dev --resource-group rg-terraform-lab-dev

## 8️⃣ Listar Variables de entorno
az webapp config appsettings list --name app-nsf-dev --resource-group rg-terraform-lab-dev

# 🧰 Comandos opcionales (solo si hay error)
## Si la autenticación administrada vuelve a "false", reactívala manualmente:
az resource update \
  --ids $(az webapp show --name app-nsf-dev --resource-group rg-terraform-lab-dev --query id -o tsv) \
  --set properties.acrUseManagedIdentityCreds=true

# 🧾 Resumen de comandos principales
terraform init -reconfigure -upgrade -backend-config="backend/backend.dev.tfvars"
terraform fmt
terraform validate
terraform plan -var-file="vars/terraform.dev.tfvars"
terraform apply -var-file="vars/terraform.dev.tfvars" -auto-approve

# 🧠 Conceptos Clave
## Concepto  	      |   Descripción
## Backend remoto	  |   Almacena el estado de Terraform en un Storage Account seguro.
## Managed Identity	|   Permite al App Service autenticarse en el ACR sin contraseñas.
## AcrPull Role	    |   Permiso necesario para que el App Service descargue imágenes desde el ACR.

# 🧑‍💻 Autor
## Alfredo Tornero