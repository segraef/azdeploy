Param( 
  [string]$resourceGroupName,
  [string]$resourceGroupLocation,
  [string]$resourceGroupCommand,
  [string]$templateFile,
  [string]$parametersFile
)

$workspace = $($env:GITHUB_WORKSPACE)
$workflow = $($env:GITHUB_WORKFLOW)
$repository = $($env:GITHUB_REPOSITORY)

Write-Output $workspace
Write-Output $workspace
Write-Output $repository

if (-not $resourceGroupName) {
  Write-Output "resourceGroupName is not set."
  exit
}

if (-not $resourceGroupCommand -or ($resourceGroupCommand -like "create")) {
  Write-Output "Executing commands to Create/Update resource group."
  if (-not (Get-AzResourceGroup -Name $resourceGroupName)) {
    if ($resourceGroupLocation ) {
      New-AzResourceGroup -Name $resourceGroupName -Location "$resourceGroupLocation"
    }
    else {
      Write-Output "resourceGroupLocation is not set."
    }
  }
}

if (-not $parametersFile) {
  Write-Output "Parameters file parametersFile does not exists." 
}

if ($templateFile) {
  $DeploymentInputs = @{
    #Name                  = "$(moduleName)-$(moduleVersion)-$(Get-Date -Format yyyyMMddHHMMss)"
    ResourceGroupName     = "$resourceGroupName"
    TemplateFile          = "$workspace/${templateFile}"
    TemplateParameterFile = "$workspace/${parametersFile}"
    Mode                  = "Incremental"
    Verbose               = $true
    ErrorAction           = "Stop"
  }

  New-AzResourceGroupDeployment @DeploymentInputs
}