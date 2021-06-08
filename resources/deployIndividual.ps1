$resourceGroup="1-d81d4f12-playground-sandbox"
$adminPass="Holamundo123"

################# Deploy DataBase ##########################
Write-Output "Deploying Data base resources"
az deployment group create -g $resourceGroup `
  --template-file ./database/database.json `
  --parameters @database/database.parameters.json `
  --parameters adminPassword=$adminPass

################# Deploy Storage Account ##########################
Write-Output "Deploying Storage Account resources"
az deployment group create -g $resourceGroup `
  --template-file ./storageAccounts/storageAccounts.json `
  --parameters @storageAccounts/storageAccounts.parameters.json `
