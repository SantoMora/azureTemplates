$resourceGroup=""

################# Deploy Storage Account ##########################
Write-Output "Deploying Storage Account resources"
$prereq = az deployment group create -g $resourceGroup `
  --template-file ./prereq/storageAccounts/storageAccounts.json `
  --parameters @prereq/storageAccounts/storageAccounts.parameters.json `
  --query properties.outputs

if($prereq) {
  Write-Output "Prereq: $prereq"
  $prereq = $prereq | ConvertFrom-Json

  Write-Output "Deploying Resources" 
  az deployment group create -g $resourceGroup `
    --template-file ./template.json

} else {
  Write-Output "Can't continue because prereq deploy error..."
}
