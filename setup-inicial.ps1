# Script de Configuración Inicial - Azure Partner Specialization
# Este script automatiza la configuración inicial necesaria

param(
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory=$false)]
    [string]$ServicePrincipalName = "sp-alz-deployment",
    
    [Parameter(Mandatory=$false)]
    [string]$CustomerName = "Pemex"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Configuración Inicial - Azure ALZ" -ForegroundColor Cyan
Write-Host "Cliente: $CustomerName" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Azure CLI
Write-Host "[1/5] Verificando Azure CLI..." -ForegroundColor Yellow

# Refrescar PATH para incluir rutas recientemente instaladas
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Verificar si az está disponible
$azCommand = Get-Command az -ErrorAction SilentlyContinue

# Si no está en PATH, buscar en ubicaciones comunes
if (-not $azCommand) {
    $commonPaths = @(
        "$env:ProgramFiles\Microsoft SDKs\Azure\CLI2\wbin\az.cmd",
        "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\CLI2\wbin\az.cmd",
        "$env:LOCALAPPDATA\Microsoft\WindowsApps\az.cmd",
        "$env:USERPROFILE\.azure\cliextensions\az.cmd"
    )
    
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            $env:Path = "$([System.IO.Path]::GetDirectoryName($path));$env:Path"
            $azCommand = Get-Command az -ErrorAction SilentlyContinue
            if ($azCommand) {
                Write-Host "   Azure CLI encontrado en: $path" -ForegroundColor Gray
                break
            }
        }
    }
}

# Si aún no se encuentra, intentar refrescar PATH desde registro
if (-not $azCommand) {
    try {
        $azureCliPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
            Where-Object { $_.DisplayName -like "*Azure CLI*" } | 
            Select-Object -First 1).InstallLocation
        
        if ($azureCliPath -and (Test-Path "$azureCliPath\wbin\az.cmd")) {
            $env:Path = "$azureCliPath\wbin;$env:Path"
            $azCommand = Get-Command az -ErrorAction SilentlyContinue
        }
    } catch {
        # Ignorar errores de registro
    }
}

# Verificación final
if (-not $azCommand) {
    Write-Host "❌ Azure CLI no está instalado o no está en PATH." -ForegroundColor Red
    Write-Host "" -ForegroundColor Red
    Write-Host "   Soluciones:" -ForegroundColor Yellow
    Write-Host "   1. Instala Azure CLI desde: https://aka.ms/InstallAzureCLI" -ForegroundColor Yellow
    Write-Host "   2. O ejecuta: winget install Microsoft.AzureCLI" -ForegroundColor Yellow
    Write-Host "   3. Después de instalar, CIERRA y REABRE PowerShell" -ForegroundColor Yellow
    Write-Host "   4. O ejecuta: refreshenv (si tienes Chocolatey)" -ForegroundColor Yellow
    Write-Host "" -ForegroundColor Yellow
    exit 1
}

# Verificar versión
try {
    $azVersion = az version --output json 2>$null | ConvertFrom-Json
    Write-Host "✅ Azure CLI instalado (versión: $($azVersion.'azure-cli'))" -ForegroundColor Green
} catch {
    Write-Host "✅ Azure CLI instalado" -ForegroundColor Green
}

# Verificar login
Write-Host "[2/5] Verificando login en Azure..." -ForegroundColor Yellow
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Host "⚠️  No estás logueado en Azure." -ForegroundColor Yellow
    Write-Host "   Ejecutando 'az login'..." -ForegroundColor Yellow
    az login
    $account = az account show | ConvertFrom-Json
}

Write-Host "✅ Logueado como: $($account.user.name)" -ForegroundColor Green
Write-Host "   Suscripción actual: $($account.name)" -ForegroundColor Gray

# Verificar/cambiar suscripción
if ($account.id -ne $SubscriptionId) {
    Write-Host "[3/5] Cambiando a suscripción: $SubscriptionId..." -ForegroundColor Yellow
    az account set --subscription $SubscriptionId
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ No se pudo cambiar a la suscripción especificada." -ForegroundColor Red
        Write-Host "   Verifica que tengas acceso a: $SubscriptionId" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "✅ Suscripción cambiada exitosamente" -ForegroundColor Green
} else {
    Write-Host "[3/5] ✅ Ya estás en la suscripción correcta" -ForegroundColor Green
}

# Verificar permisos
Write-Host "[4/5] Verificando permisos..." -ForegroundColor Yellow
$userPrincipalName = $account.user.name
$roleAssignments = az role assignment list --assignee $userPrincipalName --scope "/subscriptions/$SubscriptionId" --output json | ConvertFrom-Json

$hasOwner = $roleAssignments | Where-Object { $_.roleDefinitionName -eq "Owner" }
$hasContributor = $roleAssignments | Where-Object { $_.roleDefinitionName -eq "Contributor" }

if (-not $hasOwner -and -not $hasContributor) {
    Write-Host "⚠️  No tienes permisos de Owner o Contributor." -ForegroundColor Yellow
    Write-Host "   Necesitas estos permisos para desplegar ALZ." -ForegroundColor Yellow
    Write-Host "   Contacta al administrador de la suscripción." -ForegroundColor Yellow
} else {
    Write-Host "✅ Permisos verificados" -ForegroundColor Green
}

# Crear Service Principal
Write-Host "[5/5] Creando Service Principal..." -ForegroundColor Yellow
Write-Host "   Nombre: $ServicePrincipalName" -ForegroundColor Gray

# Verificar si ya existe
$existingSP = az ad sp list --display-name $ServicePrincipalName --query "[0]" --output json 2>$null | ConvertFrom-Json

if ($existingSP) {
    Write-Host "⚠️  Service Principal ya existe: $($existingSP.appId)" -ForegroundColor Yellow
    $response = Read-Host "¿Deseas crear uno nuevo? (s/n)"
    if ($response -ne "s") {
        Write-Host "✅ Usando Service Principal existente" -ForegroundColor Green
        exit 0
    }
}

# Crear nuevo Service Principal
Write-Host "   Creando Service Principal..." -ForegroundColor Gray
$spOutput = az ad sp create-for-rbac `
    --name $ServicePrincipalName `
    --role contributor `
    --scopes "/subscriptions/$SubscriptionId" `
    --sdk-auth 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al crear Service Principal:" -ForegroundColor Red
    Write-Host $spOutput -ForegroundColor Red
    exit 1
}

# Parsear JSON
try {
    $spJson = $spOutput | ConvertFrom-Json
    Write-Host "✅ Service Principal creado exitosamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "CONFIGURACIÓN COMPLETADA" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📋 INFORMACIÓN PARA GITHUB SECRETS:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. AZURE_CREDENTIALS (pega TODO el JSON siguiente):" -ForegroundColor Cyan
    Write-Host ($spOutput | ConvertTo-Json -Depth 10) -ForegroundColor White
    Write-Host ""
    Write-Host "2. AZURE_SUBSCRIPTION_ID:" -ForegroundColor Cyan
    Write-Host "   $($spJson.subscriptionId)" -ForegroundColor White
    Write-Host ""
    Write-Host "3. AZURE_TENANT_ID:" -ForegroundColor Cyan
    Write-Host "   $($spJson.tenantId)" -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️  IMPORTANTE:" -ForegroundColor Red
    Write-Host "   - Guarda esta información de forma segura" -ForegroundColor Yellow
    Write-Host "   - El clientSecret solo se muestra UNA VEZ" -ForegroundColor Yellow
    Write-Host "   - No compartas esta información públicamente" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📝 Próximos pasos:" -ForegroundColor Cyan
    Write-Host "   1. Ve a GitHub → Settings → Secrets → Actions" -ForegroundColor White
    Write-Host "   2. Agrega los 3 secrets mostrados arriba" -ForegroundColor White
    Write-Host "   3. Ejecuta el workflow de GitHub Actions" -ForegroundColor White
    Write-Host ""
    
    # Guardar en archivo (opcional)
    $saveFile = Read-Host "¿Deseas guardar esta información en un archivo? (s/n)"
    if ($saveFile -eq "s") {
        $outputFile = "sp-credentials-$CustomerName-$(Get-Date -Format 'yyyyMMdd').json"
        $spOutput | Out-File -FilePath $outputFile -Encoding UTF8
        Write-Host "✅ Información guardada en: $outputFile" -ForegroundColor Green
        Write-Host "   ⚠️  ELIMINA este archivo después de configurar los secrets!" -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Error al procesar la salida del Service Principal" -ForegroundColor Red
    Write-Host "   Salida recibida:" -ForegroundColor Yellow
    Write-Host $spOutput -ForegroundColor Gray
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Configuración completada exitosamente" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

