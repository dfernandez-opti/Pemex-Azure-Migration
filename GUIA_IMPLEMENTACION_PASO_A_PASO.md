# Guía de Implementación Paso a Paso
## Especialización Azure Partner - Desde Cero

Esta guía te llevará paso a paso desde tener nada en Azure hasta tener toda la evidencia necesaria para la auditoría.

---

## 📋 Fase 1: Preparación del Entorno Azure

### Paso 1.1: Crear Service Principal para CI/CD

Necesitas crear un Service Principal en Azure que será usado por GitHub Actions y Azure DevOps para desplegar recursos.

```powershell
# 1. Login a Azure
az login

# 2. Seleccionar la suscripción (reemplaza con tu Subscription ID)
az account set --subscription "TU-SUBSCRIPTION-ID"

# 3. Crear Service Principal con permisos de Contributor
az ad sp create-for-rbac --name "sp-pemex-alz-deployment" `
    --role contributor `
    --scopes /subscriptions/TU-SUBSCRIPTION-ID `
    --sdk-auth

# Guarda la salida JSON - la necesitarás para configurar secrets
```

**Salida esperada (ejemplo):**
```json
{
  "clientId": "xxxx-xxxx-xxxx-xxxx",
  "clientSecret": "xxxx-xxxx-xxxx-xxxx",
  "subscriptionId": "xxxx-xxxx-xxxx-xxxx",
  "tenantId": "xxxx-xxxx-xxxx-xxxx",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

**⚠️ IMPORTANTE:** Guarda esta información de forma segura. El `clientSecret` solo se muestra una vez.

### Paso 1.2: Verificar Permisos

```powershell
# Verificar que tienes permisos suficientes
az account show
az role assignment list --assignee "TU-USER-PRINCIPAL-NAME" --scope /subscriptions/TU-SUBSCRIPTION-ID
```

Necesitas ser **Owner** o tener permisos para:
- Crear Resource Groups
- Crear deployments a nivel de Subscription
- Asignar roles RBAC
- Crear Management Groups (si usas ALZ completo)

---

## 📋 Fase 2: Configurar GitHub Actions

### Paso 2.1: Configurar Secrets en GitHub

1. Ve a tu repositorio en GitHub
2. Settings → Secrets and variables → Actions
3. Agrega los siguientes secrets:

**Para Pemex-Azure-Migration:**
- `AZURE_CREDENTIALS`: Pega TODO el JSON del service principal (del Paso 1.1)
- `AZURE_SUBSCRIPTION_ID`: Tu Subscription ID
- `AZURE_TENANT_ID`: Tu Tenant ID

### Paso 2.2: Verificar Workflow

El workflow ya está creado en: `.github/workflows/deploy-alz.yml`

**Verifica que el archivo existe:**
```powershell
# Desde el directorio raíz del proyecto
Get-Content "Pemex-Azure-Migration\.github\workflows\deploy-alz.yml" | Select-Object -First 20
```

### Paso 2.3: Ejecutar Primer Workflow (Validación)

1. Ve a tu repositorio en GitHub
2. Actions → Deploy Azure Landing Zone (ALZ) - Pemex
3. Click en "Run workflow"
4. Selecciona:
   - Branch: `main` o `develop`
   - Environment: `production`
   - Subscription ID: Tu subscription ID
5. Click "Run workflow"

**Esto ejecutará:**
- ✅ Security scanning (CodeQL, secret scanning)
- ✅ Validación de templates
- ⚠️ NO desplegará aún (solo validará)

---

## 📋 Fase 3: Configurar Azure DevOps (Opcional)

Si prefieres usar Azure DevOps en lugar de GitHub Actions:

### Paso 3.1: Crear Service Connection

1. Ve a tu Azure DevOps project
2. Project Settings → Service connections
3. New service connection → Azure Resource Manager
4. Service principal (automatic)
5. Scope level: Subscription
6. Subscription: Selecciona tu suscripción
7. Resource group: (dejar vacío o crear uno)
8. Service connection name: `Pemex-Azure-ServiceConnection`
9. Save

### Paso 3.2: Crear Variable Group

1. Pipelines → Library
2. + Variable group
3. Name: `Pemex-Azure-DevOps-Variables`
4. Agregar variables:
   - `subscriptionId`: Tu Subscription ID
   - `location`: `eastus` (o tu región preferida)
5. Save

### Paso 3.3: Crear Environment

1. Pipelines → Environments
2. New environment
3. Name: `Pemex-Production`
4. Type: None
5. Create

---

## 📋 Fase 4: Primera Ejecución Local (Recomendado)

Antes de ejecutar en CI/CD, prueba localmente:

### Paso 4.1: Preparar Scripts

```powershell
# Navegar al directorio de scripts
cd "Pemex-Azure-Migration\3.0-Manage-Optimize\3.1-Repeatable-Deployment\ALZ-Deployment\deployment-scripts"

# Verificar que el script existe
Get-ChildItem
```

### Paso 4.2: Validar Template (Sin Desplegar)

```powershell
# Solo validar, NO desplegar
.\deploy-alz.ps1 `
    -SubscriptionId "TU-SUBSCRIPTION-ID" `
    -Location "eastus" `
    -ValidateOnly
```

**Esto debería:**
- ✅ Validar el template
- ✅ Mostrar errores si los hay
- ✅ NO crear recursos en Azure

### Paso 4.3: Desplegar ALZ (Primera Vez)

Una vez que la validación pase:

```powershell
# Desplegar con ALZ Review
.\deploy-alz.ps1 `
    -SubscriptionId "TU-SUBSCRIPTION-ID" `
    -Location "eastus" `
    -ResourceGroupName "rg-pemex-alz-deployment" `
    -RunALZReview
```

**⏱️ Tiempo estimado:** 30-60 minutos

**Esto creará:**
- Resource Group
- Management Groups (si aplica)
- Policies
- Log Analytics Workspace
- Y otros recursos según el template

### Paso 4.4: Verificar Despliegue

```powershell
# Ver el estado del despliegue
az deployment sub list --subscription "TU-SUBSCRIPTION-ID" --query "[?name=='alz-deployment-*']" --output table

# Ver recursos creados
az group list --subscription "TU-SUBSCRIPTION-ID" --query "[?contains(name, 'pemex')]" --output table
```

---

## 📋 Fase 5: Ejecutar en CI/CD

### Paso 5.1: Ejecutar GitHub Actions Workflow Completo

1. Ve a GitHub → Actions
2. Selecciona "Deploy Azure Landing Zone (ALZ) - Pemex"
3. Run workflow
4. Ingresa:
   - Subscription ID
   - Environment: production
5. Ejecutar

**El workflow hará:**
1. Security scanning
2. Validación de templates
3. Despliegue de ALZ
4. Ejecución de ALZ Review
5. Generación de artifacts

### Paso 5.2: Revisar Artefactos Generados

Después de que el workflow complete:

1. Ve a la ejecución del workflow
2. Scroll down a "Artifacts"
3. Descarga:
   - `security-scan-results`
   - `deployment-artifacts`
   - `policy-compliance`
   - `sbom`

### Paso 5.3: Guardar Evidencia

Los artifacts descargados son tu evidencia para la auditoría. Guárdalos en:

```
Pemex-Azure-Migration/
├── 3.0-Manage-Optimize/
│   ├── 3.1-Repeatable-Deployment/
│   │   ├── deployment-evidence/
│   │   │   └── [copiar logs del workflow aquí]
│   │   └── ALZ-Review-Assessment/
│   │       └── [copiar resultados del ALZ Review aquí]
│   └── 3.3-Operations-Management/
│       ├── security-scan-reports/
│       │   └── [copiar security scan results aquí]
│       └── monitoring-dashboards/
│           └── [exportar dashboards de Azure Monitor]
```

---

## 📋 Fase 6: Repetir para Pemex

Repite los pasos 1-5 para el repositorio de Pemex:

1. Crear service principal (o reutilizar con diferentes permisos)
2. Configurar secrets en GitHub
3. Ejecutar workflows
4. Guardar evidencia

---

## 📋 Fase 7: Configurar Operations Management (3.3)

### Paso 7.1: Azure Monitor

```powershell
# Verificar que Log Analytics Workspace fue creado
az monitor log-analytics workspace list --query "[?contains(name, 'pemex')]" --output table

# Exportar dashboard (desde Azure Portal)
# 1. Ve a Azure Portal → Monitor → Dashboards
# 2. Crea o selecciona un dashboard
# 3. Export → Save as JSON
# 4. Guarda en: Pemex-Azure-Migration/3.0-Manage-Optimize/3.3-Operations-Management/monitoring-dashboards/
```

### Paso 7.2: Azure Automation

```powershell
# Crear Automation Account (si no existe)
az automation account create `
    --name "aa-pemex-automation" `
    --resource-group "rg-pemex-alz-deployment" `
    --location "eastus" `
    --sku "Basic"
```

### Paso 7.3: Azure Backup

```powershell
# Verificar que Backup está configurado (debería estar en el ALZ template)
az backup vault list --query "[?contains(name, 'pemex')]" --output table
```

---

## 📋 Fase 8: Documentar Todo

### Paso 8.1: Crear Deployment Logs

Los scripts y workflows ya generan logs automáticamente, pero puedes crear un resumen:

```markdown
# Deployment Summary - Pemex
- Date: [Fecha]
- Deployment Method: GitHub Actions / Azure DevOps / Manual
- Subscription ID: [ID]
- Resources Created: [Lista]
- ALZ Review Score: [Score]
- Security Scans: ✅ Passed
```

### Paso 8.2: Capturar Screenshots

Toma screenshots de:
- ✅ Pipeline ejecutándose exitosamente
- ✅ Security scan results
- ✅ ALZ Review results
- ✅ Azure Portal mostrando recursos creados
- ✅ Policy compliance dashboard

---

## 🚨 Troubleshooting Común

### Error: "Insufficient permissions"
```powershell
# Verificar permisos
az role assignment list --assignee "TU-SP-CLIENT-ID" --scope /subscriptions/TU-SUBSCRIPTION-ID

# Si falta, agregar Owner
az role assignment create `
    --assignee "TU-SP-CLIENT-ID" `
    --role "Owner" `
    --scope /subscriptions/TU-SUBSCRIPTION-ID
```

### Error: "Template validation failed"
```powershell
# Validar manualmente
az deployment sub validate `
    --location "eastus" `
    --template-file "Plantilla.json" `
    --parameters @Parametros.json
```

### Error: "ALZ Review extension not found"
```powershell
# Instalar extensión
az extension add --name alz-review
# O actualizar
az extension update --name alz-review
```

### Error: "Resource group already exists"
```powershell
# Eliminar y recrear (CUIDADO: esto elimina recursos)
az group delete --name "rg-pemex-alz-deployment" --yes

# O usar un nombre diferente
.\deploy-alz.ps1 -ResourceGroupName "rg-pemex-alz-deployment-v2"
```

---

## ✅ Checklist de Verificación

Antes de considerar completo, verifica:

### Infraestructura Azure
- [ ] Service Principal creado
- [ ] Permisos configurados correctamente
- [ ] Resource Group creado
- [ ] ALZ desplegado exitosamente
- [ ] ALZ Review ejecutado y resultados guardados

### CI/CD
- [ ] Secrets configurados en GitHub/Azure DevOps
- [ ] Workflow ejecutado exitosamente
- [ ] Security scans pasaron
- [ ] Deployment logs generados
- [ ] Artifacts descargados y guardados

### Evidencia
- [ ] Deployment logs con timestamps
- [ ] Security scan reports (sanitizados)
- [ ] ALZ Review results
- [ ] Policy compliance snapshots
- [ ] SBOM generado
- [ ] Monitoring dashboards exportados

### Documentación
- [ ] README actualizado
- [ ] Deployment evidence documentada
- [ ] Screenshots capturados
- [ ] Troubleshooting documentado

---

## 🎯 Próximos Pasos Después de Esta Fase

Una vez completado el despliegue de ALZ:

1. **3.2 Plan for Skilling**: Crear planes de capacitación
2. **1.1 Workload Assessment**: Crear assessments de migración
3. **2.1 Solution Design**: Crear diseños de solución

---

## 📞 Soporte

Si encuentras problemas:
1. Revisa los logs del deployment
2. Verifica permisos en Azure
3. Revisa la documentación de ALZ: https://aka.ms/alzreview
4. Consulta los troubleshooting steps arriba

---

**Última Actualización:** $(Get-Date -Format "yyyy-MM-dd")  
**Estado:** Listo para ejecución

