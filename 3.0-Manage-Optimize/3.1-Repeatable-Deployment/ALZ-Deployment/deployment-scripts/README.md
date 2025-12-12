# Scripts de Despliegue Automatizado - ALZ

Este directorio contiene scripts para el despliegue automatizado de Azure Landing Zone (ALZ).

## Scripts Disponibles

### PowerShell: `deploy-alz.ps1`
Script PowerShell para despliegue de ALZ en Windows o PowerShell Core.

**Uso:**
```powershell
.\deploy-alz.ps1 `
    -SubscriptionId "your-subscription-id" `
    -Location "eastus" `
    -ResourceGroupName "rg-pemex-alz-deployment" `
    -RunALZReview
```

**Parámetros:**
- `-SubscriptionId` (Requerido): ID de la suscripción de Azure
- `-Location` (Opcional): Región de Azure (default: eastus)
- `-ResourceGroupName` (Opcional): Nombre del resource group (default: rg-pemex-alz-deployment)
- `-TemplateFile` (Opcional): Ruta al template (default: arm-templates/ALZ-Template.json)
- `-ParametersFile` (Opcional): Ruta a parámetros (default: arm-templates/ALZ-Parameters.json)
- `-DeploymentName` (Opcional): Nombre del despliegue (default: auto-generado)
- `-ValidateOnly` (Switch): Solo validar, no desplegar
- `-RunALZReview` (Switch): Ejecutar Azure Landing Zone Review después del despliegue

### Bash: `deploy-alz.sh`
Script Bash para despliegue de ALZ en Linux/macOS/WSL.

**Uso:**
```bash
chmod +x deploy-alz.sh
./deploy-alz.sh \
    --subscription-id "your-subscription-id" \
    --location "eastus" \
    --resource-group "rg-pemex-alz-deployment" \
    --run-alz-review
```

**Parámetros:**
- `-s, --subscription-id` (Requerido): ID de la suscripción de Azure
- `-l, --location` (Opcional): Región de Azure (default: eastus)
- `-g, --resource-group` (Opcional): Nombre del resource group (default: rg-pemex-alz-deployment)
- `-t, --template` (Opcional): Ruta al template
- `-p, --parameters` (Opcional): Ruta a parámetros
- `-n, --deployment-name` (Opcional): Nombre del despliegue
- `-v, --validate-only`: Solo validar, no desplegar
- `-r, --run-alz-review`: Ejecutar Azure Landing Zone Review
- `-h, --help`: Mostrar ayuda

## Prerrequisitos

1. **Azure CLI instalado:**
   - Windows: `winget install -e --id Microsoft.AzureCLI`
   - Linux: Ver [instrucciones oficiales](https://aka.ms/InstallAzureCLI)
   - macOS: `brew install azure-cli`

2. **Autenticación en Azure:**
   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```

3. **Permisos necesarios:**
   - Owner o Contributor en la suscripción
   - Permisos para crear resource groups
   - Permisos para crear deployments a nivel de suscripción

## Características

✅ Validación automática de templates antes del despliegue  
✅ Creación automática de resource group si no existe  
✅ Logging detallado con timestamps  
✅ Manejo robusto de errores  
✅ Integración con Azure Landing Zone Review  
✅ Generación automática de deployment logs  
✅ Soporte para validación sin despliegue  

## Outputs

Los scripts generan:

1. **Deployment Logs**: En `../deployment-evidence/deployment-log-YYYYMMDD-HHMMSS.md`
2. **ALZ Review Results**: En `../ALZ-Review-Assessment/azure-landing-zone-review-results.json` (si se ejecuta con `-RunALZReview`)

## Integración con CI/CD

Estos scripts están diseñados para ser utilizados por:
- GitHub Actions workflows (`.github/workflows/deploy-alz.yml`)
- Azure DevOps pipelines (`.azure-pipelines/azure-pipelines.yml`)

Los pipelines ejecutan automáticamente:
- Security scanning (CodeQL, secret scanning)
- Template validation
- Despliegue automatizado
- ALZ Review assessment
- Generación de artifacts

## Troubleshooting

### Error: "Not logged in to Azure"
```bash
az login
```

### Error: "Template validation failed"
- Verificar que los parámetros sean correctos
- Revisar la sintaxis del template JSON
- Ejecutar con `-ValidateOnly` para ver detalles del error

### Error: "Insufficient permissions"
- Verificar que la cuenta tenga permisos de Owner o Contributor
- Verificar que la suscripción esté activa

## Seguridad

⚠️ **Importante:**
- Los scripts NO almacenan credenciales
- Utilizan Azure CLI para autenticación
- Los logs generados están sanitizados (sin PII)
- Los secretos deben manejarse mediante Azure Key Vault o variables de entorno

