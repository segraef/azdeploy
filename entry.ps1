Param( 
  [string]$resourceGroupName,
  [string]$resourceGroupLocation,
  [string]$resourceGroupCommand,
  [string]$templateFile,
  [string]$parametersFile
)

$context = Get-AzContext
if (!$context) {
  Write-Output "No Azure context found! Please make sure azlogin has run before."
  exit
} 

if (-not $resourceGroupName) {
  Write-Output "resourceGroupName is not set."
  exit
}

if ($resourceGroupCommand -and ($resourceGroupCommand -like "create")) {
  Write-Output "Executing commands to Create/Update resource group."
  if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
    if ($resourceGroupLocation) {
      New-AzResourceGroup -Name $resourceGroupName -Location "$resourceGroupLocation"
    }
    else {
      Write-Output "resourceGroupLocation is not set."
      exit
    }
  }
}

if ($templateFile -and $parametersFile) {
  $DeploymentInputs = @{
    Name                  = "$($env:GITHUB_WORKFLOW)-$($env:GITHUB_ACTOR)-$(Get-Date -Format yyyyMMddHHMMss)"
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
  Write-Output "Template or parameters file does not exist." 
}

if ($resourceGroupCommand -like "delete") {
  Write-Output "resourceGroupCommand is set to 'delete'. Removing $resourceGroupName now. "
  Remove-AzResourceGroup -Name $resourceGroupName -Force
}