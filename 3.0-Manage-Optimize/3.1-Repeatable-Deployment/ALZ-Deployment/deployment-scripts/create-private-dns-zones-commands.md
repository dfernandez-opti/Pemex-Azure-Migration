# Comandos Azure CLI para Crear Private DNS Zones - Pemex ALZ

## Comando Único (PowerShell)

```powershell
# Configurar variables
$subscriptionId = "922fcb86-d9bc-4c9a-8782-b4f40a87559e"
$resourceGroup = "Pemex-privatedns"
$location = "westus2"

# Crear Resource Group (si no existe)
az group create --name $resourceGroup --location $location --subscription $subscriptionId --tags Environment=Production Project="Pemex-ALZ"

# Crear todas las Private DNS Zones
$zones = @(
    "privatelink.blob.core.windows.net",
    "privatelink.file.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.database.windows.net",
    "privatelink.documents.azure.com",
    "privatelink.vaultcore.azure.net",
    "privatelink.azurewebsites.net",
    "privatelink.servicebus.windows.net",
    "privatelink.eventgrid.azure.net",
    "privatelink.wus2.backup.windowsazure.com"
)

foreach ($zone in $zones) {
    az network private-dns zone create --name $zone --resource-group $resourceGroup --subscription $subscriptionId --tags Environment=Production Project="Pemex-ALZ"
}
```

## Comando Único (Bash/Linux)

```bash
# Configurar variables
SUBSCRIPTION_ID="922fcb86-d9bc-4c9a-8782-b4f40a87559e"
RESOURCE_GROUP="Pemex-privatedns"
LOCATION="westus2"

# Crear Resource Group (si no existe)
az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --subscription "$SUBSCRIPTION_ID" --tags Environment=Production Project="Pemex-ALZ"

# Crear todas las Private DNS Zones
for zone in \
    "privatelink.blob.core.windows.net" \
    "privatelink.file.core.windows.net" \
    "privatelink.queue.core.windows.net" \
    "privatelink.table.core.windows.net" \
    "privatelink.dfs.core.windows.net" \
    "privatelink.database.windows.net" \
    "privatelink.documents.azure.com" \
    "privatelink.vaultcore.azure.net" \
    "privatelink.azurewebsites.net" \
    "privatelink.servicebus.windows.net" \
    "privatelink.eventgrid.azure.net" \
    "privatelink.wus2.backup.windowsazure.com"; do
    az network private-dns zone create --name "$zone" --resource-group "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION_ID" --tags Environment=Production Project="Pemex-ALZ"
done
```

## Comandos Individuales (si prefieres ejecutarlos uno por uno)

```bash
# 1. Crear Resource Group
az group create \
  --name "Pemex-privatedns" \
  --location "westus2" \
  --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" \
  --tags Environment=Production Project="Pemex-ALZ"

# 2. Crear cada Private DNS Zone
az network private-dns zone create --name "privatelink.blob.core.windows.net" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"

az network private-dns zone create --name "privatelink.file.core.windows.net" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"

az network private-dns zone create --name "privatelink.queue.core.windows.net" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"

az network private-dns zone create --name "privatelink.table.core.windows.net" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"

az network private-dns zone create --name "privatelink.dfs.core.windows.net" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"

az network private-dns zone create --name "privatelink.database.windows.net" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"

az network private-dns zone create --name "privatelink.documents.azure.com" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"

az network private-dns zone create --name "privatelink.vaultcore.azure.net" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"

az network private-dns zone create --name "privatelink.azurewebsites.net" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"

az network private-dns zone create --name "privatelink.servicebus.windows.net" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"

az network private-dns zone create --name "privatelink.eventgrid.azure.net" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"

az network private-dns zone create --name "privatelink.wus2.backup.windowsazure.com" --resource-group "Pemex-privatedns" --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" --tags Environment=Production Project="Pemex-ALZ"
```

## Usar el Script Automatizado

### PowerShell:
```powershell
.\create-private-dns-zones.ps1 -SubscriptionId "922fcb86-d9bc-4c9a-8782-b4f40a87559e"
```

### Bash:
```bash
chmod +x create-private-dns-zones.sh
./create-private-dns-zones.sh -s "922fcb86-d9bc-4c9a-8782-b4f40a87559e"
```

## Verificar Zonas Creadas

```bash
az network private-dns zone list \
  --resource-group "Pemex-privatedns" \
  --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e" \
  --output table
```

## Lista de Zonas que se Crearán

1. `privatelink.blob.core.windows.net` - Azure Blob Storage
2. `privatelink.file.core.windows.net` - Azure Files
3. `privatelink.queue.core.windows.net` - Azure Queue Storage
4. `privatelink.table.core.windows.net` - Azure Table Storage
5. `privatelink.dfs.core.windows.net` - Azure Data Lake Storage Gen2
6. `privatelink.database.windows.net` - Azure SQL Database
7. `privatelink.documents.azure.com` - Azure Cosmos DB
8. `privatelink.vaultcore.azure.net` - Azure Key Vault
9. `privatelink.azurewebsites.net` - Azure App Service
10. `privatelink.servicebus.windows.net` - Azure Service Bus
11. `privatelink.eventgrid.azure.net` - Azure Event Grid
12. `privatelink.wus2.backup.windowsazure.com` - Azure Backup (West US 2)

---

**Nota:** Asegúrate de estar autenticado en Azure CLI antes de ejecutar los comandos:
```bash
az login
az account set --subscription "922fcb86-d9bc-4c9a-8782-b4f40a87559e"
```

