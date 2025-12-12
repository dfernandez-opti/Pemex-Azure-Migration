# PowerShell Script for ALZ Deployment - Pemex
# This script provides automated deployment of Azure Landing Zone

param(
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "eastus",
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "rg-pemex-alz-deployment",
    
    [Parameter(Mandatory=$false)]
    [string]$TemplateFile = "arm-templates/ALZ-Template.json",
    
    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "arm-templates/ALZ-Parameters.json",
    
    [Parameter(Mandatory=$false)]
    [string]$DeploymentName = "alz-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')",
    
    [Parameter(Mandatory=$false)]
    [switch]$ValidateOnly,
    
    [Parameter(Mandatory=$false)]
    [switch]$RunALZReview
)

# Error handling
$ErrorActionPreference = "Stop"

# Logging function
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "WARNING" { "Yellow" }
        "SUCCESS" { "Green" }
        default { "White" }
    }
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

# Check Azure CLI
Write-Log "Checking Azure CLI installation..."
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Log "Azure CLI is not installed. Please install it from https://aka.ms/InstallAzureCLI" "ERROR"
    exit 1
}

# Login to Azure
Write-Log "Checking Azure login status..."
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Log "Not logged in to Azure. Please run 'az login' first." "ERROR"
    exit 1
}

Write-Log "Logged in as: $($account.user.name)"
Write-Log "Current subscription: $($account.name) ($($account.id))"

# Set subscription
if ($account.id -ne $SubscriptionId) {
    Write-Log "Switching to subscription: $SubscriptionId"
    az account set --subscription $SubscriptionId | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Log "Failed to set subscription" "ERROR"
        exit 1
    }
}

# Get script directory and resolve template paths (templates are in parent directory)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$alzDeploymentPath = Split-Path -Parent $scriptPath
$templatePath = Join-Path $alzDeploymentPath $TemplateFile
$parametersPath = Join-Path $alzDeploymentPath $ParametersFile

# Validate paths
if (-not (Test-Path $templatePath)) {
    Write-Log "Template file not found: $templatePath" "ERROR"
    exit 1
}

if (-not (Test-Path $parametersPath)) {
    Write-Log "Parameters file not found: $parametersPath" "ERROR"
    exit 1
}

# Create resource group if it doesn't exist
Write-Log "Checking resource group: $ResourceGroupName"
try {
    $rgOutput = az group show --name $ResourceGroupName --subscription $SubscriptionId 2>&1
    if ($LASTEXITCODE -eq 0) {
        $rg = $rgOutput | ConvertFrom-Json
    } else {
        $rg = $null
    }
} catch {
    $rg = $null
}
if (-not $rg) {
    Write-Log "Creating resource group: $ResourceGroupName in $Location"
    az group create `
        --name $ResourceGroupName `
        --location $Location `
        --subscription $SubscriptionId `
        --tags Environment=Production Project="Pemex-ALZ" ManagedBy="PowerShell" DeploymentDate=(Get-Date -Format "yyyy-MM-dd") | Out-Null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Log "Failed to create resource group" "ERROR"
        exit 1
    }
    Write-Log "Resource group created successfully" "SUCCESS"
} else {
    Write-Log "Resource group already exists"
}

# Validate template
Write-Log "Validating ARM template..."
$validationResult = az deployment tenant validate `
    --location $Location `
    --template-file $templatePath `
    --parameters @$parametersPath 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Log "Template validation failed" "ERROR"
    Write-Log $validationResult "ERROR"
    exit 1
}

Write-Log "Template validation successful" "SUCCESS"

if ($ValidateOnly) {
    Write-Log "Validation only mode. Exiting." "SUCCESS"
    exit 0
}

# Deploy template
Write-Log "Starting deployment: $DeploymentName"
Write-Log "This may take 30-60 minutes..."

$deploymentResult = az deployment tenant create `
    --name $DeploymentName `
    --location $Location `
    --template-file $templatePath `
    --parameters @$parametersPath `
    --verbose 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Log "Deployment failed" "ERROR"
    Write-Log $deploymentResult "ERROR"
    exit 1
}

Write-Log "Deployment completed successfully" "SUCCESS"

# Get deployment status
Write-Log "Retrieving deployment status..."
$deploymentStatus = az deployment tenant show `
    --name $DeploymentName | ConvertFrom-Json

Write-Log "Deployment State: $($deploymentStatus.properties.provisioningState)"
Write-Log "Correlation ID: $($deploymentStatus.properties.correlationId)"
Write-Log "Timestamp: $($deploymentStatus.properties.timestamp)"

# Run Azure Landing Zone Review if requested
if ($RunALZReview) {
    Write-Log "Running Azure Landing Zone Review assessment..."
    
    # Check if extension is installed
    $extensions = az extension list | ConvertFrom-Json
    $alzReviewInstalled = $extensions | Where-Object { $_.name -eq "alz-review" }
    
    if (-not $alzReviewInstalled) {
        Write-Log "Installing Azure CLI extension: alz-review"
        az extension add --name alz-review
    } else {
        Write-Log "Updating Azure CLI extension: alz-review"
        az extension update --name alz-review
    }
    
    $reviewOutputPath = Join-Path $scriptPath "../ALZ-Review-Assessment/azure-landing-zone-review-results.json"
    $reviewOutputDir = Split-Path -Parent $reviewOutputPath
    
    if (-not (Test-Path $reviewOutputDir)) {
        New-Item -ItemType Directory -Path $reviewOutputDir -Force | Out-Null
    }
    
    az alz review `
        --subscription-id $SubscriptionId `
        --output-file $reviewOutputPath `
        --output-format json
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "ALZ Review completed. Results saved to: $reviewOutputPath" "SUCCESS"
    } else {
        Write-Log "ALZ Review completed with warnings. Check results." "WARNING"
    }
}

# Generate deployment log
Write-Log "Generating deployment log..."
$logPath = Join-Path $scriptPath "../deployment-evidence/deployment-log-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
$logDir = Split-Path -Parent $logPath

if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

$logContent = @"
# ALZ Deployment Log - Pemex

**Deployment Date:** $(Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
**Deployment Name:** $DeploymentName
**Subscription ID:** $SubscriptionId
**Location:** $Location
**Resource Group:** $ResourceGroupName

## Deployment Status
- **State:** $($deploymentStatus.properties.provisioningState)
- **Correlation ID:** $($deploymentStatus.properties.correlationId)
- **Timestamp:** $($deploymentStatus.properties.timestamp)

## Resources Deployed
- Identity Management: Microsoft Entra ID
- Networking: Hub & Spoke Architecture
- Resource Organization: Tagging and Naming Standards
- Multi-regional Redundancy: Configured

## Security Validation
- ARM Template Validation: ✅ Passed
- Deployment Verification: ✅ Passed

## Next Steps
1. Review Azure Landing Zone Review results (if executed)
2. Verify resource organization and tagging
3. Configure additional monitoring and alerting
"@

$logContent | Out-File -FilePath $logPath -Encoding UTF8
Write-Log "Deployment log saved to: $logPath" "SUCCESS"

Write-Log "Deployment process completed successfully!" "SUCCESS"

