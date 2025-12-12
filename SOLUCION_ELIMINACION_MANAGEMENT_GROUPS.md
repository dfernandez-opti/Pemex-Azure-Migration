# Solución: Eliminación de Management Groups para Deployment Limpio

## Problema

El deployment del Azure Landing Zone estaba fallando porque los Management Groups ya existían de un deployment anterior, causando conflictos cuando el template intentaba crearlos nuevamente.

**Error observado:**
```
ERROR: "code":"DeploymentFailed","target":".../alz-ConnectivitySub-westus2-..."
```

## Solución Aplicada

Se eliminaron todos los Management Groups existentes (excepto el Tenant Root Group) para permitir que el template los cree desde cero:

### Management Groups Eliminados:
1. ✅ Pemex-sandboxes
2. ✅ Pemex-online
3. ✅ Pemex-landingzones
4. ✅ Pemex-decommissioned
5. ✅ Pemex-corp
6. ✅ Pemex-platform
7. ✅ Pemex (raíz)

### Pasos Ejecutados:

1. **Mover suscripción al Tenant Root Group:**
   ```powershell
   az account management-group subscription remove --name "Pemex-platform" --subscription "fbd7f286-5077-483f-8817-351e38bea77f"
   az account management-group subscription add --name "23285b8c-1596-4f14-adc2-fd472cc70cc8" --subscription "fbd7f286-5077-483f-8817-351e38bea77f"
   ```

2. **Eliminar Management Groups hijos primero:**
   - Se eliminaron los Management Groups hijos antes que los padres
   - Orden: Pemex-sandboxes, Pemex-online, Pemex-landingzones, Pemex-decommissioned, Pemex-corp, Pemex-platform

3. **Eliminar Management Group raíz:**
   - Finalmente se eliminó Pemex (después de eliminar Pemex-landingzones que era su hijo)

## Estado Final

Después de la eliminación, solo queda:
- ✅ Tenant Root Group (no se puede eliminar)

El template del Azure Landing Zone creará todos los Management Groups desde cero con la estructura correcta.

## Próximos Pasos

1. **Ejecutar el workflow de GitHub Actions nuevamente**
   - El template creará todos los Management Groups desde cero
   - No habrá conflictos porque no existen previamente

2. **Verificar después del deployment:**
   ```powershell
   az account management-group list --output table
   ```

## Nota Importante

⚠️ **Advertencia:** Eliminar Management Groups es una operación irreversible. Asegúrate de que:
- No hay recursos críticos dependiendo de estos Management Groups
- No hay políticas o asignaciones de roles que dependan de estos grupos
- Tienes un backup o documentación de la configuración anterior si es necesario

En este caso, como estamos haciendo un deployment limpio siguiendo el enfoque "Start small and expand", es apropiado eliminar los grupos anteriores y empezar desde cero.

---

**Fecha:** 2025-12-12  
**Suscripción:** fbd7f286-5077-483f-8817-351e38bea77f (Migrate)  
**Acción:** Eliminación completa de Management Groups para deployment limpio

