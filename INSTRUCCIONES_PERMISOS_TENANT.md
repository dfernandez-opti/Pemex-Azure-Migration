# Instrucciones para Otorgar Permisos de Tenant al Service Principal

## Problema Actual

El Service Principal `sp-pemex-alz-deployment` no tiene permisos para crear deployments a nivel de tenant, lo cual es necesario para desplegar Azure Landing Zone con Management Groups.

**Error recibido:**
```
AuthorizationFailed: The client does not have authorization to perform action 
'Microsoft.Resources/deployments/validate/action' over scope 
'/providers/Microsoft.Resources/deployments/...'
```

## Solución: Otorgar Permisos a Nivel de Tenant

### Requisitos Previos

- Debes ser **Global Administrator** o **User Access Administrator** del tenant de Pemex
- Debes tener Azure CLI instalado y autenticado
- Debes estar logueado con una cuenta que tenga estos permisos

### Pasos para Otorgar Permisos

1. **Autenticarse en Azure CLI:**
   ```powershell
   az login
   ```

2. **Verificar que estás en el tenant correcto:**
   ```powershell
   az account show --query "{tenantId:tenantId, tenantDomain:tenantDefaultDomain}"
   ```
   
   Debe mostrar:
   - **Tenant ID:** `23285b8c-1596-4f14-adc2-fd472cc70cc8`
   - **Tenant Domain:** `PEMEXDEV.onmicrosoft.com`

3. **Otorgar el rol "User Access Administrator" a nivel de tenant:**
   ```powershell
   az role assignment create `
       --assignee "15f3ca73-6b45-4bc7-bdd5-ad317b6291b8" `
       --role "User Access Administrator" `
       --scope "/"
   ```

4. **Verificar que el permiso fue otorgado:**
   ```powershell
   az role assignment list --assignee "15f3ca73-6b45-4bc7-bdd5-ad317b6291b8" --scope "/" --output table
   ```

   Debe mostrar una entrada con:
   - **Role:** `User Access Administrator`
   - **Scope:** `/`

### Información del Service Principal

- **Nombre:** `sp-pemex-alz-deployment`
- **Object ID:** `15f3ca73-6b45-4bc7-bdd5-ad317b6291b8`
- **Client ID (App ID):** `f00ef9ae-8e5d-4978-ab31-3878ecf3ec65`
- **Subscription ID:** `fbd7f286-5077-483f-8817-351e38bea77f`
- **Tenant ID:** `23285b8c-1596-4f14-adc2-fd472cc70cc8`

### Alternativa (No Recomendada)

Si por alguna razón no puedes usar "User Access Administrator", puedes usar "Global Administrator" (tiene más permisos de los necesarios):

```powershell
az role assignment create `
    --assignee "15f3ca73-6b45-4bc7-bdd5-ad317b6291b8" `
    --role "Global Administrator" `
    --scope "/"
```

**Nota:** Global Administrator otorga más permisos de los necesarios. User Access Administrator es suficiente y más seguro.

## Después de Otorgar Permisos

Una vez otorgados los permisos:

1. Espera 1-2 minutos para que los permisos se propaguen
2. Vuelve a ejecutar el workflow en GitHub Actions
3. El deployment debería proceder sin errores de autorización

## Verificación de Permisos Completos

Para ver todos los permisos del Service Principal:

```powershell
az role assignment list --assignee "15f3ca73-6b45-4bc7-bdd5-ad317b6291b8" --all --output table
```

Debe mostrar:
- **Contributor** a nivel de suscripción
- **Owner** a nivel de suscripción  
- **User Access Administrator** a nivel de suscripción
- **User Access Administrator** a nivel de tenant (nuevo)

---

**Contacto:** Si tienes problemas, contacta al equipo de Azure en Pemex.

**Fecha:** 2025-12-12

