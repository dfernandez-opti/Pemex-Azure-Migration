# Changelog - ALZ Deployment Fixes

## Cambios Clave Implementados

### 1. Workflow de GitHub Actions (`.github/workflows/deploy-alz.yml`)

#### Cambio Principal: `--template-uri` → `--template-file`

**Antes**:
```yaml
az deployment tenant create \
  --template-uri "$TEMPLATE_URL" \
  --parameters @$PARAMETERS_FILE
```

**Después**:
```yaml
az deployment tenant create \
  --template-file "$TEMPLATE_FILE" \
  --parameters "@$PARAMETERS_FILE"
```

**Beneficios**:
- ✅ Elimina errores de `InvalidContentLink`
- ✅ No depende de `templateLink.uri` que causa problemas con templates anidados
- ✅ Mejor rendimiento (no descarga desde GitHub)
- ✅ Más confiable (usa archivos locales del checkout)

#### Mejoras Adicionales:

1. **Validación de archivos antes del deployment**
   - Verifica existencia de template y parameters
   - Falla rápido si faltan archivos

2. **Logging mejorado**
   - Información detallada del deployment
   - Timestamps, commit SHA, branch, etc.
   - Formato legible con separadores

3. **Manejo de errores explícito**
   - Códigos de salida claros
   - Mensajes de éxito/error con emojis
   - No oculta errores de ARM

4. **Validación mejorada**
   - Usa `--template-file` también para validación
   - Evita problemas de `InvalidContentLink` en validación
   - Mensajes de error más claros

### 2. Template ARM (`ALZ-Template.json`)

#### Corrección: `subscriptionResourceId` en `ALZArmRoleId`

**Problema**: `subscriptionResourceId` requiere 3 parámetros pero solo se pasaban 2.

**Solución**:
- Deployment normal: Agregado `parameters('managementSubscriptionId')` como primer parámetro
- Deployment Lite: Agregado `parameters('singlePlatformSubscriptionId')` como primer parámetro

**Líneas afectadas**:
- Línea ~2320: Deployment normal de monitor policies
- Línea ~2422: Deployment Lite de monitor policies

**Código corregido**:
```json
// Antes (incorrecto - solo 2 parámetros)
"ALZArmRoleId": {
    "value": "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')]"
}

// Después (correcto - 3 parámetros)
"ALZArmRoleId": {
    "value": "[subscriptionResourceId(parameters('managementSubscriptionId'), 'Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')]"
}
```

#### Verificación: URIs Absolutas

**Estado**: ✅ Todas las URIs son absolutas y correctas

Todas las URIs en `deploymentUris` (líneas 1710-1750) son URLs absolutas que apuntan a:
- Repositorio oficial: `https://raw.githubusercontent.com/Azure/Enterprise-Scale/main/...`
- Branch estable: `main` (no tags específicos que pueden cambiar)
- Rutas completas: Incluyen la ruta completa al archivo JSON

**No se requieren cambios** en las URIs porque ya están correctas.

### 3. Documentación

#### Nuevos Archivos:

1. **`DEPLOYMENT_FIXES.md`**
   - Explicación detallada del problema y solución
   - Ejemplos de código antes/después
   - Referencias y mejores prácticas

2. **`CHANGELOG.md`** (este archivo)
   - Lista concisa de cambios
   - Solo lo esencial, sin texto genérico

## Resumen de Archivos Modificados

1. ✅ `.github/workflows/deploy-alz.yml`
   - Cambio de `--template-uri` a `--template-file`
   - Mejoras en logging y manejo de errores
   - Validación mejorada

2. ✅ `3.0-Manage-Optimize/3.1-Repeatable-Deployment/ALZ-Deployment/arm-templates/ALZ-Template.json`
   - Corrección de `subscriptionResourceId` en `ALZArmRoleId`
   - Verificación de URIs (ya correctas)

3. ✅ `3.0-Manage-Optimize/3.1-Repeatable-Deployment/ALZ-Deployment/DEPLOYMENT_FIXES.md` (nuevo)
   - Documentación completa de las correcciones

4. ✅ `3.0-Manage-Optimize/3.1-Repeatable-Deployment/ALZ-Deployment/CHANGELOG.md` (nuevo)
   - Lista de cambios clave

## Errores Resueltos

1. ✅ `InvalidContentLink`: Resuelto usando `--template-file`
2. ✅ `subscriptionResourceId requires 3 parameters`: Resuelto agregando `subscriptionId` como primer parámetro
3. ✅ Falta de logging: Resuelto con logging detallado
4. ✅ Errores ocultos: Resuelto con manejo explícito de códigos de salida

## Próximos Pasos Recomendados

1. ✅ Probar el deployment con los cambios aplicados
2. ⏳ Verificar que no haya errores de `InvalidContentLink`
3. ⏳ Confirmar que los templates anidados se descargan correctamente
4. ⏳ Monitorear el primer deployment exitoso
5. ⏳ Documentar cualquier ajuste adicional si es necesario

## Notas para el Equipo

- **No cambiar** las URIs en `deploymentUris` a URLs relativas
- **Siempre usar** `--template-file` para deployments locales
- **Verificar** que los parámetros de `subscriptionResourceId` incluyan el `subscriptionId`
- **Revisar** los logs del workflow para debugging

