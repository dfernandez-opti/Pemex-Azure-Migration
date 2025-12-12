# Quick Start - Implementación Rápida

## 🚀 Inicio Rápido (5 Pasos)

### 1. Login y Preparación (5 minutos)

```powershell
# Login a Azure
az login

# Ver suscripciones disponibles
az account list --output table

# Seleccionar suscripción
az account set --subscription "TU-SUBSCRIPTION-ID"
```

### 2. Crear Service Principal y Otorgar Permisos (5 minutos)

```powershell
# Crear SP para GitHub Actions
az ad sp create-for-rbac --name "sp-pemex-alz-deployment" `
    --role contributor `
    --scopes /subscriptions/TU-SUBSCRIPTION-ID `
    --sdk-auth

# ⚠️ GUARDA LA SALIDA JSON - la necesitarás
# Obtén el appId de la salida JSON

# Obtener el Object ID del Service Principal
$spObjectId = (az ad sp show --id "TU-APP-ID" --query id -o tsv)

# ⚠️ IMPORTANTE: Otorgar permisos a nivel de TENANT para deployments
# Necesitas ser Global Administrator o User Access Administrator
# Opción 1: User Access Administrator (Recomendado - menos permisos)
az role assignment create `
    --assignee $spObjectId `
    --role "User Access Administrator" `
    --scope "/"

# Opción 2: Global Administrator (Solo si no tienes User Access Administrator)
# az role assignment create --assignee $spObjectId --role "Global Administrator" --scope "/"

# Verificar permisos
az role assignment list --assignee $spObjectId --scope "/" --output table
```

**⚠️ NOTA IMPORTANTE**: 
- Necesitas permisos de **Global Administrator** o **User Access Administrator** para otorgar estos roles
- El rol **User Access Administrator** es suficiente y más seguro que Global Administrator
- Si no tienes estos permisos, contacta a tu administrador de Azure AD

### 3. Configurar GitHub Secrets (3 minutos)

1. GitHub → Tu Repo → Settings → Secrets → Actions
2. Agregar:
   - `AZURE_CREDENTIALS`: Pega TODO el JSON del paso 2
   - `AZURE_SUBSCRIPTION_ID`: Tu Subscription ID
   - `AZURE_TENANT_ID`: Tu Tenant ID

### 4. Validar Localmente (Opcional pero Recomendado)

```powershell
cd "Pemex-Azure-Migration\3.0-Manage-Optimize\3.1-Repeatable-Deployment\ALZ-Deployment\deployment-scripts"

# Solo validar (NO despliega)
.\deploy-alz.ps1 -SubscriptionId "TU-SUBSCRIPTION-ID" -ValidateOnly
```

### 5. Ejecutar Workflow en GitHub (30-60 minutos)

1. GitHub → Actions → "Deploy Azure Landing Zone (ALZ) - Pemex"
2. Run workflow
3. Ingresar Subscription ID
4. Esperar a que complete

**¡Listo!** Los artifacts se generarán automáticamente.

---

## 📋 Comandos Esenciales

### Verificar Estado
```powershell
# Ver deployments a nivel de tenant
az deployment tenant list --query "[?name=='alz-deployment-*']" --output table

# Ver resource groups
az group list --query "[?contains(name, 'pemex')]" --output table

# Ver recursos creados
az resource list --resource-group "rg-pemex-alz-deployment" --output table

# Ver Management Groups creados
az account management-group list --output table
```

### Ejecutar ALZ Review Manualmente
```powershell
# Instalar extensión
az extension add --name alz-review

# Ejecutar review
az alz review --subscription-id "TU-SUBSCRIPTION-ID" --output-file "alz-review.json"
```

### Limpiar (Si necesitas empezar de nuevo)
```powershell
# ⚠️ CUIDADO: Esto elimina TODO
az group delete --name "rg-pemex-alz-deployment" --yes --no-wait
```

---

## 🎯 Orden Recomendado de Ejecución

1. ✅ **Primero**: Validar localmente (`-ValidateOnly`)
2. ✅ **Segundo**: Ejecutar workflow en GitHub (solo validación)
3. ✅ **Tercero**: Ejecutar workflow completo (despliegue)
4. ✅ **Cuarto**: Revisar artifacts y guardarlos
5. ✅ **Quinto**: Verificar despliegue completo

---

## ⚠️ Checklist Antes de Desplegar

- [ ] Tienes permisos de Owner/Contributor en la suscripción
- [ ] Tienes permisos de **Global Administrator** o **User Access Administrator** a nivel de tenant
- [ ] Service Principal creado y JSON guardado
- [ ] Service Principal tiene rol **User Access Administrator** a nivel de tenant (`/`)
- [ ] Secrets configurados en GitHub
- [ ] Validación local pasó exitosamente
- [ ] Tienes 30-60 minutos disponibles (tiempo de despliegue)
- [ ] Backup de información importante (si aplica)

---

## 🆘 Si Algo Sale Mal

1. **Revisa los logs del workflow** en GitHub Actions
2. **Verifica permisos a nivel de tenant**: 
   ```powershell
   $spObjectId = (az ad sp show --id "TU-APP-ID" --query id -o tsv)
   az role assignment list --assignee $spObjectId --scope "/" --output table
   ```
3. **Valida template manualmente**: 
   ```powershell
   az deployment tenant validate --location eastus --template-uri "URL" --parameters @parameters.json
   ```
4. **Si falta autorización**: Asegúrate de que el SP tenga rol "User Access Administrator" a nivel de tenant
5. **Consulta la guía completa**: `GUIA_IMPLEMENTACION_PASO_A_PASO.md`

---

**Tiempo Total Estimado:** 1-2 horas (incluyendo tiempo de despliegue)

