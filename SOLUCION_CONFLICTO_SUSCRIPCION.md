# Solución: Conflicto al Agregar Suscripción al Management Group

## Problema

Durante el deployment del Azure Landing Zone, se produjo el siguiente error:

```
ERROR: "code":"Conflict","message":"Failed to add subscription to management group"
```

**Causa:** La suscripción `fbd7f286-5077-483f-8817-351e38bea77f` ya estaba asignada al Management Group `Pemex-platform`, pero el template ARM intentaba moverla nuevamente a ese mismo Management Group, causando un conflicto.

## Solución Aplicada

Se movió temporalmente la suscripción al **Tenant Root Group** para que el template ARM pueda moverla correctamente a `Pemex-platform` durante el deployment.

### Comando Ejecutado

```powershell
az account management-group subscription add --name "23285b8c-1596-4f14-adc2-fd472cc70cc8" --subscription "fbd7f286-5077-483f-8817-351e38bea77f"
```

**Resultado:** La suscripción ahora está en el Tenant Root Group y lista para ser movida por el template.

## Próximos Pasos

1. **Ejecutar el workflow de GitHub Actions nuevamente**
   - El template ahora debería poder mover la suscripción a `Pemex-platform` sin conflictos
   - El deployment debería completarse exitosamente

2. **Verificar después del deployment**
   ```powershell
   az account management-group show --name "Pemex-platform" --expand --query "children[?type=='/subscriptions'].{Name:name, DisplayName:displayName}" --output table
   ```

## Prevención Futura

Si necesitas ejecutar el deployment nuevamente y la suscripción ya está en `Pemex-platform`, mueve la suscripción al Tenant Root Group antes de ejecutar el deployment:

```powershell
# Mover al Tenant Root Group
az account management-group subscription add --name "23285b8c-1596-4f14-adc2-fd472cc70cc8" --subscription "fbd7f286-5077-483f-8817-351e38bea77f"
```

## Nota Técnica

El template anidado `subscriptionOrganization.json` de Azure Enterprise Scale no maneja el caso donde la suscripción ya está en el Management Group objetivo. Por lo tanto, es necesario mover la suscripción manualmente antes del deployment si ya está en el Management Group correcto.

---

**Fecha:** 2025-12-12  
**Suscripción:** fbd7f286-5077-483f-8817-351e38bea77f (Migrate)  
**Management Group Objetivo:** Pemex-platform

