Param( 
  [string]$resourceGroupName,
  [string]$resourceGroupLocation,
  [string]$resourceGroupCommand,
  [string]$templateFile,
  [string]$parametersFile
)

$context = Get-AzContext
if (!$context) 
{
  Write-Output "No Azure context found! Please make sure azlogin has run before."
  exit
} 

if (-not $resourceGroupName) {
  Write-Output "resourceGroupName is not set."
  exit
}

if (-not $resourceGroupCommand -and ($resourceGroupCommand -like "create")) {
  Write-Output "Executing commands to Create/Update resource group."
  if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
    if ($resourceGroupLocation ) {
      New-AzResourceGroup -Name $resourceGroupName -Location "$resourceGroupLocation"
    }
    else {
      Write-Output "resourceGroupLocation is not set."
      exit
    }
  }
  else {
    if (-not $parametersFile) {
      Write-Output "Parameters file parametersFile does not exists." 
    }
    else {
      if ($templateFile) {
        $DeploymentInputs = @{
          ResourceGroupName     = "$resourceGroupName"
          TemplateFile          = "$templateFile"
          TemplateParameterFile = "$parametersFile"
          Mode                  = "Incremental"
          Verbose               = $true
          ErrorAction           = "Stop"
        }
      
        New-AzResourceGroupDeployment @DeploymentInputs
      }
      else {
        Write-Output "Template file templateFile does not exists." 
      }
    }
  }
}
elseif ($resourceGroupCommand -like "delete") {
  Remove-AzResourceGroup -Name $resourceGroupName -Force
}