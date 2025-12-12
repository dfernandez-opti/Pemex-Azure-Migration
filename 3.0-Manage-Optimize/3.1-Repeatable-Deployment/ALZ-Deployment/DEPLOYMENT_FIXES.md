# ALZ Deployment Fixes - InvalidContentLink Resolution

## Resumen de Cambios

Este documento describe las correcciones aplicadas para resolver el error `InvalidContentLink` en el despliegue del Azure Landing Zone (ALZ).

## Problema Identificado

El error `InvalidContentLink` ocurría porque:

1. **Templates anidados de Enterprise-Scale**: Los templates anidados intentan usar `deployment().properties.templateLink.uri` para construir URIs relativas
2. **Deployment desde URL**: Cuando se usa `--template-uri`, Azure no puede resolver correctamente las URIs relativas de los templates anidados
3. **Validación fallida**: La validación del template fallaba antes de poder desplegar

## Soluciones Implementadas

### 1. Cambio de `--template-uri` a `--template-file`

**Archivo**: `.github/workflows/deploy-alz.yml`

**Cambio**:
- **Antes**: Usaba `--template-uri` con URL de GitHub
- **Después**: Usa `--template-file` con archivo local del checkout

**Razón**:
- Evita el problema de `InvalidContentLink` porque no depende de `templateLink.uri`
- Los templates anidados siguen usando sus URLs absolutas (ya correctas en `deploymentUris`)
- Mejor rendimiento al no necesitar descargar el template desde GitHub

**Código**:
```yaml
# Antes
az deployment tenant create \
  --template-uri "$TEMPLATE_URL" \
  --parameters @$PARAMETERS_FILE

# Después
az deployment tenant create \
  --template-file "$TEMPLATE_FILE" \
  --parameters "@$PARAMETERS_FILE"
```

### 2. Mejora del Logging y Manejo de Errores

**Archivo**: `.github/workflows/deploy-alz.yml`

**Mejoras**:
- Validación de existencia de archivos antes del deployment
- Logging detallado con información del deployment
- Manejo explícito de códigos de salida
- Mensajes claros de éxito/error

**Ejemplo de output**:
```
==========================================
ALZ Deployment Information
==========================================
Deployment Name: alz-deployment-1765490211
Template File: 3.0-Manage-Optimize/3.1-Repeatable-Deployment/ALZ-Deployment/arm-templates/ALZ-Template.json
Parameters File: 3.0-Manage-Optimize/3.1-Repeatable-Deployment/ALZ-Deployment/arm-templates/ALZ-Parameters.json
Location: eastus
Subscription: 922fcb86-d9bc-4c9a-8782-b4f40a87559e
Workflow Run: 123456789
Commit SHA: abc123def456
Branch: main
Timestamp: 2025-12-11T21:43:21Z
==========================================
```

### 3. Verificación de URIs Absolutas en Template

**Archivo**: `ALZ-Template.json`

**Estado**: ✅ Todas las URIs son absolutas

Todas las URIs en la variable `deploymentUris` son URLs absolutas que apuntan al repositorio oficial de Azure Enterprise-Scale:

```json
"deploymentUris": {
    "managementGroups": "https://raw.githubusercontent.com/Azure/Enterprise-Scale/main/eslzArm/managementGroupTemplates/mgmtGroupStructure/mgmtGroups.json",
    "vnetConnectivityHub": "https://raw.githubusercontent.com/Azure/Enterprise-Scale/main/eslzArm/subscriptionTemplates/hubspoke-connectivity.json",
    // ... todas las demás son URLs absolutas
}
```

**No se requieren cambios** en el template porque todas las URIs ya son correctas.

### 4. Corrección de `subscriptionResourceId`

**Archivo**: `ALZ-Template.json`

**Problema**: `subscriptionResourceId` requiere 3 parámetros pero solo se estaban pasando 2.

**Corrección**:
- Agregado `subscriptionId` como primer parámetro en `ALZArmRoleId`
- Deployment normal: usa `parameters('managementSubscriptionId')`
- Deployment Lite: usa `parameters('singlePlatformSubscriptionId')`

**Código corregido**:
```json
// Deployment normal (línea ~2320)
"ALZArmRoleId": {
    "value": "[subscriptionResourceId(parameters('managementSubscriptionId'), 'Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')]"
}

// Deployment Lite (línea ~2422)
"ALZArmRoleId": {
    "value": "[subscriptionResourceId(parameters('singlePlatformSubscriptionId'), 'Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')]"
}
```

## Estructura de Archivos

```
3.0-Manage-Optimize/
└── 3.1-Repeatable-Deployment/
    └── ALZ-Deployment/
        ├── arm-templates/
        │   ├── ALZ-Template.json       # Template principal (sin cambios en URIs)
        │   └── ALZ-Parameters.json    # Parámetros del template
        ├── deployment-scripts/
        │   ├── deploy-alz.ps1         # Script PowerShell local
        │   └── deploy-alz.sh         # Script Bash local
        └── DEPLOYMENT_FIXES.md        # Este documento
```

## Workflow de GitHub Actions

**Archivo**: `.github/workflows/deploy-alz.yml`

**Jobs principales**:
1. `security-scan`: Escaneo de secretos con TruffleHog
2. `arm-template-linter`: Validación con ARM TTK
3. `validate-templates`: Validación de estructura ARM
4. `deploy-alz`: Deployment del ALZ (usa `--template-file`)
5. `generate-sbom`: Generación de SBOM

## Mejores Prácticas Aplicadas

1. ✅ **URIs Absolutas**: Todas las URIs de templates anidados son absolutas
2. ✅ **Template Local**: Uso de `--template-file` para evitar problemas de `templateLink.uri`
3. ✅ **Validación de Archivos**: Verificación de existencia antes del deployment
4. ✅ **Logging Detallado**: Información completa del deployment en logs
5. ✅ **Manejo de Errores**: Códigos de salida explícitos y mensajes claros
6. ✅ **Documentación**: Comentarios inline y este documento de referencia

## Próximos Pasos

1. ✅ Probar el deployment con los cambios aplicados
2. ✅ Verificar que no haya errores de `InvalidContentLink`
3. ✅ Confirmar que los templates anidados se descargan correctamente
4. ✅ Documentar cualquier ajuste adicional necesario

## Referencias

- [Azure Resource Manager Templates](https://docs.microsoft.com/azure/azure-resource-manager/templates/)
- [Azure Enterprise-Scale Landing Zone](https://github.com/Azure/Enterprise-Scale)
- [ARM Template Functions](https://docs.microsoft.com/azure/azure-resource-manager/templates/template-functions)

