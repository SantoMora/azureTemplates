$resourceGroup="1-ca8ac45a-playground-sandbox"
$adminPass="Holamundo123"
$backupContainer="backups"
$landingContainer="landing"
$backupSource="./data/backup"
$csvSource="./data/CSV"

################# Deploy Storage Account ##########################
Write-Output "Deploying Storage Account resources"
$prereq = az deployment group create -g $resourceGroup `
  --template-file ./prereqs/storageAccounts/storageAccounts.json `
  --parameters @prereqs/storageAccounts/storageAccount.parameters.json `
  --query properties.outputs `
  #--output jsonc

if($prereq) {
  Write-Output "Prereq: $prereq"
  $prereq = $prereq | ConvertFrom-Json

  Write-Output "Uploading bacap database to $backupContainer..."
  $bacpac = az storage blob upload-batch --destination $backupContainer `
    --account-name $prereq.storageAF.value `
    --connection-string $prereq.storageAFConctStr.value `
    --destination-path .\ `
    --source $backupSource

  $bacpac = $bacpac | ConvertFrom-Json
  Write-Output $bacpac[0].Blob

  Write-Output "Uploading CSV test files to $landingContainer..."
  az storage blob upload-batch --destination $landingContainer `
    --account-name $prereq.storageDL.value `
    --connection-string $prereq.storageDLConctStr.value `
    --destination-path .\ `
    --source $csvSource
  
  Write-Output "Deploying Resources" 
  az deployment group create -g $resourceGroup `
    --template-file ./template.json `
    --parameters storageKey=$prereq.storageAFKey.value bacpacUrl=$bacpac[0].Blob adminPassword=$adminPass
  
} else {
  Write-Output "Can't continue because prereq deploy error..."
}
