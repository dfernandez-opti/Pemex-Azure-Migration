# Solución: Error de Private DNS Zones con Virtual WAN Hub

## Problema

Durante el deployment del Azure Landing Zone, se produjeron múltiples errores:

```
ERROR: "code":"BadRequest","message":"The specified virtual network ID is invalid."
```

**Causa:** El template está configurado para usar Virtual WAN Hub (`enableHub: "vhub"`), pero los Private DNS Zones intentan vincularse a una red virtual hub tradicional que no existe cuando se usa Virtual WAN Hub.

**Detalles técnicos:**
- `enableHub: "vhub"` crea un Virtual WAN Hub, no una red virtual tradicional
- `enablePrivateDnsZones: "Yes"` intenta crear vínculos a `vNetHubResourceId`
- Con Virtual WAN Hub, no hay una red virtual hub tradicional disponible para vincular
- El template anidado `privateDnsZones.json` espera una red virtual tradicional

## Solución Aplicada

Se deshabilitaron temporalmente los Private DNS Zones para permitir que el deployment continúe:

```json
"enablePrivateDnsZones": {
  "value": "No"
}
```

## Justificación

Siguiendo el enfoque **"Start small and expand"**, es apropiado deshabilitar funcionalidades avanzadas inicialmente y habilitarlas después de que la infraestructura base esté funcionando.

## Próximos Pasos

1. **Completar el deployment base** sin Private DNS Zones
2. **Después del deployment exitoso**, evaluar si se necesita Private DNS Zones
3. **Si se requiere**, considerar una de estas opciones:
   - Cambiar a una arquitectura Hub & Spoke tradicional (`enableHub: "vnet"`)
   - Crear manualmente los Private DNS Zones y vincularlos después
   - Esperar a que el template de Azure Enterprise Scale soporte Private DNS Zones con Virtual WAN Hub

## Alternativa: Cambiar a Hub & Spoke Tradicional

Si los Private DNS Zones son críticos, se puede cambiar la configuración:

```json
"enableHub": {
  "value": "vnet"  // Cambiar de "vhub" a "vnet"
}
```

Esto creará una red virtual hub tradicional que puede ser vinculada a Private DNS Zones.

## Nota Técnica

El template de Azure Enterprise Scale tiene una limitación conocida: los Private DNS Zones no se pueden vincular directamente a Virtual WAN Hubs porque estos no son redes virtuales tradicionales. Los vínculos de Private DNS Zones requieren una red virtual específica.

---

**Fecha:** 2025-12-12  
**Configuración:** Virtual WAN Hub (`enableHub: "vhub"`)  
**Private DNS Zones:** Deshabilitado temporalmente

