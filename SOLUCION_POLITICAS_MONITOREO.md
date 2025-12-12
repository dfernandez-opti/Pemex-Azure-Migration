# Solución: Error en Políticas de Monitoreo (MonitorPolicyLite)

## Problema

El deployment del Azure Landing Zone está fallando en el paso de políticas de monitoreo:

```
ERROR: "code":"DeploymentFailed","target":".../alz-MonitorPolicyLite-westus2-..."
```

**Causa:** El parámetro `enableMonitorBaselines` está configurado como `"Yes"`, lo que activa el deployment de políticas de monitoreo avanzadas que pueden estar intentando acceder a recursos que aún no existen o requieren configuraciones adicionales.

## Solución Aplicada

Se deshabilitaron temporalmente las políticas de monitoreo avanzadas para permitir que el deployment base se complete primero:

```json
"enableMonitorBaselines": {
  "value": "No"  // Cambiado de "Yes" a "No"
}
```

## Justificación

Siguiendo el enfoque **"Start small and expand"**, es apropiado:

1. **Completar primero la infraestructura base:**
   - Management Groups
   - Virtual WAN Hub
   - Resource Groups básicos
   - Políticas fundamentales

2. **Habilitar funcionalidades avanzadas después:**
   - Políticas de monitoreo avanzadas
   - Alertas y baseline monitoring
   - Service Health alerts
   - Otras funcionalidades opcionales

## Parámetros de Monitoreo Actuales

Después del cambio:
- ✅ `enableMonitorBaselines`: `"No"` (deshabilitado temporalmente)
- ✅ `enableServiceHealthBuiltIn`: `"Yes"` (mantenido - política built-in)
- ✅ `enableMonitorConnectivity`: `"Yes"` (mantenido)
- ✅ `enableMonitorIdentity`: `"Yes"` (mantenido)
- ✅ `enableMonitorManagement`: `"Yes"` (mantenido)

## Próximos Pasos

1. **Completar el deployment base** sin políticas de monitoreo avanzadas
2. **Después del deployment exitoso**, evaluar si se necesitan las políticas de monitoreo avanzadas
3. **Si se requiere**, habilitar `enableMonitorBaselines: "Yes"` y ejecutar un deployment incremental

## Alternativa: Investigar el Error Específico

Si las políticas de monitoreo son críticas, se puede investigar el error específico:

```powershell
# Ver detalles del error del deployment
az deployment management-group show \
  --management-group-id "Pemex" \
  --name "alz-MonitorPolicyLite-westus2-..." \
  --query "properties.error" \
  --output json
```

Posibles causas del error:
- Falta de permisos en el Service Principal
- Recursos dependientes que aún no existen
- Configuraciones requeridas que no están presentes
- Limitaciones del template anidado

## Nota Técnica

El template `MonitorPolicyLite` despliega políticas de Azure Policy para:
- Baseline monitoring alerts
- Service Health alerts
- Alertas de conectividad
- Alertas de identidad

Estas políticas pueden requerir recursos adicionales (como Log Analytics Workspace) que deben estar completamente configurados antes de asignar las políticas.

---

**Fecha:** 2025-12-12  
**Configuración:** `enableMonitorBaselines: "No"` (temporal)  
**Enfoque:** Start small and expand

