# Solución al Error de Autorización en GitHub Actions

## Problema

El workflow de GitHub Actions falla con el error:
```
AuthorizationFailed: The client does not have authorization to perform action 
'Microsoft.Resources/deployments/validate/action' over scope 
'/providers/Microsoft.Resources/deployments/...'
```

## Estado Actual

**El Service Principal SÍ tiene los permisos necesarios:**
- ✅ User Access Administrator a nivel de tenant (`/`)
- ✅ Owner a nivel de suscripción
- ✅ User Access Administrator a nivel de suscripción
- ✅ Contributor a nivel de suscripción

**Permiso otorgado el:** 2025-12-12T17:26:26

## Posibles Causas del Error

1. **Propagación de permisos:** Los permisos pueden tardar 5-15 minutos en propagarse completamente
2. **Credenciales cacheadas:** GitHub Actions puede estar usando credenciales antiguas
3. **Token expirado:** El token del Service Principal puede necesitar refrescarse

## Soluciones

### Solución 1: Esperar y Reintentar (Recomendado)

1. Espera 5-10 minutos desde que se otorgaron los permisos
2. Vuelve a ejecutar el workflow en GitHub Actions
3. Los permisos deberían estar completamente propagados

### Solución 2: Refrescar las Credenciales en GitHub

Si el problema persiste después de esperar:

1. Ve a GitHub → Settings → Secrets and variables → Actions
2. Elimina el secret `AZURE_CREDENTIALS`
3. Regenera las credenciales del Service Principal:

```powershell
# Obtener el clientSecret actual (si lo tienes guardado)
# O crear un nuevo secret si es necesario
az ad sp credential reset --id "f00ef9ae-8e5d-4978-ab31-3878ecf3ec65" --append
```

4. Actualiza el secret `AZURE_CREDENTIALS` en GitHub con el nuevo JSON

### Solución 3: Verificar Permisos Directamente

Ejecuta este comando para verificar que los permisos están activos:

```powershell
az role assignment list --assignee "15f3ca73-6b45-4bc7-bdd5-ad317b6291b8" --scope "/" --output table
```

Debe mostrar:
```
Role                       Scope
-------------------------  -------
User Access Administrator  /
```

### Solución 4: Probar Deployment Manualmente

Para verificar que los permisos funcionan, prueba crear un deployment de prueba:

```powershell
az deployment tenant validate `
    --location "eastus" `
    --template-file "3.0-Manage-Optimize/3.1-Repeatable-Deployment/ALZ-Deployment/arm-templates/ALZ-Template.json" `
    --parameters "@3.0-Manage-Optimize/3.1-Repeatable-Deployment/ALZ-Deployment/arm-templates/ALZ-Parameters.json"
```

Si este comando funciona, entonces el problema es con las credenciales en GitHub Actions.

## Información del Service Principal

- **Object ID:** `15f3ca73-6b45-4bc7-bdd5-ad317b6291b8`
- **Client ID:** `f00ef9ae-8e5d-4978-ab31-3878ecf3ec65`
- **Nombre:** `sp-pemex-alz-deployment`

## Próximos Pasos

1. ✅ Permisos otorgados correctamente
2. ⏳ Esperar 5-10 minutos para propagación
3. 🔄 Re-ejecutar el workflow en GitHub Actions
4. ✅ El deployment debería funcionar

---

**Última actualización:** 2025-12-12 17:30

