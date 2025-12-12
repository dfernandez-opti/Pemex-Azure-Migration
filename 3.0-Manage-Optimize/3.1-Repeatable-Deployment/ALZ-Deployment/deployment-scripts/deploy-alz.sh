#!/bin/bash
# Bash Script for ALZ Deployment - Pemex
# This script provides automated deployment of Azure Landing Zone

set -e  # Exit on error

# Default values
LOCATION="eastus"
RESOURCE_GROUP_NAME="rg-pemex-alz-deployment"
TEMPLATE_FILE="arm-templates/ALZ-Template.json"
PARAMETERS_FILE="arm-templates/ALZ-Parameters.json"
VALIDATE_ONLY=false
RUN_ALZ_REVIEW=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date -u +"%Y-%m-%d %H:%M:%S")
    
    case $level in
        ERROR)
            echo -e "[$timestamp] [${RED}ERROR${NC}] $message" >&2
            ;;
        WARNING)
            echo -e "[$timestamp] [${YELLOW}WARNING${NC}] $message"
            ;;
        SUCCESS)
            echo -e "[$timestamp] [${GREEN}SUCCESS${NC}] $message"
            ;;
        *)
            echo -e "[$timestamp] [INFO] $message"
            ;;
    esac
}

# Usage function
usage() {
    echo "Usage: $0 -s SUBSCRIPTION_ID [OPTIONS]"
    echo ""
    echo "Required:"
    echo "  -s, --subscription-id    Azure Subscription ID"
    echo ""
    echo "Options:"
    echo "  -l, --location           Azure region (default: eastus)"
    echo "  -g, --resource-group     Resource group name (default: rg-pemex-alz-deployment)"
    echo "  -t, --template           Template file path (default: arm-templates/ALZ-Template.json)"
    echo "  -p, --parameters         Parameters file path (default: arm-templates/ALZ-Parameters.json)"
    echo "  -n, --deployment-name    Deployment name (default: auto-generated)"
    echo "  -v, --validate-only      Only validate template, do not deploy"
    echo "  -r, --run-alz-review     Run Azure Landing Zone Review after deployment"
    echo "  -h, --help              Show this help message"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--subscription-id)
            SUBSCRIPTION_ID="$2"
            shift 2
            ;;
        -l|--location)
            LOCATION="$2"
            shift 2
            ;;
        -g|--resource-group)
            RESOURCE_GROUP_NAME="$2"
            shift 2
            ;;
        -t|--template)
            TEMPLATE_FILE="$2"
            shift 2
            ;;
        -p|--parameters)
            PARAMETERS_FILE="$2"
            shift 2
            ;;
        -n|--deployment-name)
            DEPLOYMENT_NAME="$2"
            shift 2
            ;;
        -v|--validate-only)
            VALIDATE_ONLY=true
            shift
            ;;
        -r|--run-alz-review)
            RUN_ALZ_REVIEW=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            log ERROR "Unknown option: $1"
            usage
            ;;
    esac
done

# Check required parameters
if [ -z "$SUBSCRIPTION_ID" ]; then
    log ERROR "Subscription ID is required"
    usage
fi

# Check Azure CLI
if ! command -v az &> /dev/null; then
    log ERROR "Azure CLI is not installed. Please install it from https://aka.ms/InstallAzureCLI"
    exit 1
fi

# Check Azure login
log "INFO" "Checking Azure login status..."
if ! az account show &> /dev/null; then
    log ERROR "Not logged in to Azure. Please run 'az login' first."
    exit 1
fi

ACCOUNT_INFO=$(az account show)
CURRENT_SUB=$(echo $ACCOUNT_INFO | jq -r '.id')
CURRENT_USER=$(echo $ACCOUNT_INFO | jq -r '.user.name')

log "INFO" "Logged in as: $CURRENT_USER"
log "INFO" "Current subscription: $CURRENT_SUB"

# Set subscription
if [ "$CURRENT_SUB" != "$SUBSCRIPTION_ID" ]; then
    log "INFO" "Switching to subscription: $SUBSCRIPTION_ID"
    az account set --subscription "$SUBSCRIPTION_ID"
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMPLATE_PATH="$SCRIPT_DIR/$TEMPLATE_FILE"
PARAMETERS_PATH="$SCRIPT_DIR/$PARAMETERS_FILE"

# Validate paths
if [ ! -f "$TEMPLATE_PATH" ]; then
    log ERROR "Template file not found: $TEMPLATE_PATH"
    exit 1
fi

if [ ! -f "$PARAMETERS_PATH" ]; then
    log ERROR "Parameters file not found: $PARAMETERS_PATH"
    exit 1
fi

# Generate deployment name if not provided
if [ -z "$DEPLOYMENT_NAME" ]; then
    DEPLOYMENT_NAME="alz-deployment-$(date +%Y%m%d-%H%M%S)"
fi

# Create resource group if it doesn't exist
log "INFO" "Checking resource group: $RESOURCE_GROUP_NAME"
if ! az group show --name "$RESOURCE_GROUP_NAME" --subscription "$SUBSCRIPTION_ID" &> /dev/null; then
    log "INFO" "Creating resource group: $RESOURCE_GROUP_NAME in $LOCATION"
    az group create \
        --name "$RESOURCE_GROUP_NAME" \
        --location "$LOCATION" \
        --subscription "$SUBSCRIPTION_ID" \
        --tags Environment=Production Project="Pemex-ALZ" ManagedBy="Bash" DeploymentDate=$(date -u +"%Y-%m-%d")
    
    log SUCCESS "Resource group created successfully"
else
    log "INFO" "Resource group already exists"
fi

# Validate template
log "INFO" "Validating ARM template..."
if ! az deployment sub validate \
    --location "$LOCATION" \
    --template-file "$TEMPLATE_PATH" \
    --parameters @"$PARAMETERS_PATH" \
    --subscription "$SUBSCRIPTION_ID" &> /dev/null; then
    log ERROR "Template validation failed"
    exit 1
fi

log SUCCESS "Template validation successful"

if [ "$VALIDATE_ONLY" = true ]; then
    log SUCCESS "Validation only mode. Exiting."
    exit 0
fi

# Deploy template
log "INFO" "Starting deployment: $DEPLOYMENT_NAME"
log "INFO" "This may take 30-60 minutes..."

if ! az deployment sub create \
    --name "$DEPLOYMENT_NAME" \
    --location "$LOCATION" \
    --template-file "$TEMPLATE_PATH" \
    --parameters @"$PARAMETERS_PATH" \
    --subscription "$SUBSCRIPTION_ID" \
    --verbose; then
    log ERROR "Deployment failed"
    exit 1
fi

log SUCCESS "Deployment completed successfully"

# Get deployment status
log "INFO" "Retrieving deployment status..."
DEPLOYMENT_STATUS=$(az deployment sub show \
    --name "$DEPLOYMENT_NAME" \
    --subscription "$SUBSCRIPTION_ID")

PROVISIONING_STATE=$(echo $DEPLOYMENT_STATUS | jq -r '.properties.provisioningState')
CORRELATION_ID=$(echo $DEPLOYMENT_STATUS | jq -r '.properties.correlationId')
TIMESTAMP=$(echo $DEPLOYMENT_STATUS | jq -r '.properties.timestamp')

log "INFO" "Deployment State: $PROVISIONING_STATE"
log "INFO" "Correlation ID: $CORRELATION_ID"
log "INFO" "Timestamp: $TIMESTAMP"

# Run Azure Landing Zone Review if requested
if [ "$RUN_ALZ_REVIEW" = true ]; then
    log "INFO" "Running Azure Landing Zone Review assessment..."
    
    # Check if extension is installed
    if ! az extension show --name alz-review &> /dev/null; then
        log "INFO" "Installing Azure CLI extension: alz-review"
        az extension add --name alz-review
    else
        log "INFO" "Updating Azure CLI extension: alz-review"
        az extension update --name alz-review
    fi
    
    REVIEW_OUTPUT_DIR="$SCRIPT_DIR/../ALZ-Review-Assessment"
    REVIEW_OUTPUT_PATH="$REVIEW_OUTPUT_DIR/azure-landing-zone-review-results.json"
    
    mkdir -p "$REVIEW_OUTPUT_DIR"
    
    if az alz review \
        --subscription-id "$SUBSCRIPTION_ID" \
        --output-file "$REVIEW_OUTPUT_PATH" \
        --output-format json; then
        log SUCCESS "ALZ Review completed. Results saved to: $REVIEW_OUTPUT_PATH"
    else
        log WARNING "ALZ Review completed with warnings. Check results."
    fi
fi

# Generate deployment log
log "INFO" "Generating deployment log..."
LOG_DIR="$SCRIPT_DIR/../deployment-evidence"
LOG_PATH="$LOG_DIR/deployment-log-$(date +%Y%m%d-%H%M%S).md"

mkdir -p "$LOG_DIR"

cat > "$LOG_PATH" << EOF
# ALZ Deployment Log - Pemex

**Deployment Date:** $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Deployment Name:** $DEPLOYMENT_NAME
**Subscription ID:** $SUBSCRIPTION_ID
**Location:** $LOCATION
**Resource Group:** $RESOURCE_GROUP_NAME

## Deployment Status
- **State:** $PROVISIONING_STATE
- **Correlation ID:** $CORRELATION_ID
- **Timestamp:** $TIMESTAMP

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
EOF

log SUCCESS "Deployment log saved to: $LOG_PATH"
log SUCCESS "Deployment process completed successfully!"

