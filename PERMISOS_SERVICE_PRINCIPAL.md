# Permisos del Service Principal - Pemex ALZ

## Service Principal Information

- **Nombre:** `sp-pemex-alz-deployment`
- **Client ID (App ID):** `f00ef9ae-8e5d-4978-ab31-3878ecf3ec65`
- **Object ID:** `15f3ca73-6b45-4bc7-bdd5-ad317b6291b8`
- **Subscription ID:** `fbd7f286-5077-483f-8817-351e38bea77f`
- **Tenant ID:** `23285b8c-1596-4f14-adc2-fd472cc70cc8`

## Permisos Actuales (Nivel de Suscripción)

El Service Principal tiene los siguientes permisos a nivel de suscripción:

1. **Contributor** - `/subscriptions/fbd7f286-5077-483f-8817-351e38bea77f`
2. **Owner** - `/subscriptions/fbd7f286-5077-483f-8817-351e38bea77f`
3. **User Access Administrator** - `/subscriptions/fbd7f286-5077-483f-8817-351e38bea77f`

## Permisos Requeridos (Nivel de Tenant)

Para desplegar Azure Landing Zone con Management Groups, el Service Principal necesita permisos a nivel de tenant.

### Comando para Administrador del Tenant

Un administrador del tenant (Global Administrator o User Access Administrator) debe ejecutar:

```powershell
# Otorgar User Access Administrator a nivel de tenant
az role assignment create `
    --assignee "15f3ca73-6b45-4bc7-bdd5-ad317b6291b8" `
    --role "User Access Administrator" `
    --scope "/"
```

**Alternativa (si User Access Administrator no está disponible):**

```powershell
# Otorgar Global Administrator a nivel de tenant (menos recomendado, más permisos)
az role assignment create `
    --assignee "15f3ca73-6b45-4bc7-bdd5-ad317b6291b8" `
    --role "Global Administrator" `
    --scope "/"
```

## Verificar Permisos

Para verificar los permisos otorgados:

```powershell
# Ver todos los permisos del Service Principal
az role assignment list --assignee "15f3ca73-6b45-4bc7-bdd5-ad317b6291b8" --all --output table

# Verificar permisos a nivel de tenant específicamente
az role assignment list --assignee "15f3ca73-6b45-4bc7-bdd5-ad317b6291b8" --scope "/" --output table
```

## Notas Importantes

1. **User Access Administrator** es suficiente y más seguro que Global Administrator
2. Solo un **Global Administrator** o **User Access Administrator** del tenant puede otorgar estos permisos
3. Los permisos a nivel de tenant son necesarios para:
   - Crear Management Groups
   - Asignar políticas a nivel de tenant
   - Crear deployments a nivel de tenant
   - Validar templates a nivel de tenant

## Contacto

Si necesitas ayuda para otorgar estos permisos, contacta al administrador del tenant de Pemex:
- **Tenant:** PEMEXDEV.onmicrosoft.com
- **Tenant ID:** 23285b8c-1596-4f14-adc2-fd472cc70cc8

---

**Última actualización:** 2025-12-12

