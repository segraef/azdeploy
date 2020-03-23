Param( 
  [string]$resourceGroupName,
  [string]$resourceGroupLocation,
  [string]$resourceGroupCommand,
  [string]$templateFile,
  [string]$parametersFile
)

Get-Location
Get-ChildItem -recurse
Get-ChildItem $($env:GITHUB_WORKSPACE) -recurse

if (-not $resourceGroupName) {
  Write-Output "resourceGroupName is not set."
  exit
}

if (-not $resourceGroupCommand -or ($resourceGroupCommand -like "create")) {
  Write-Output "Executing commands to Create/Update resource group."
  if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
    if ($resourceGroupLocation ) {
      New-AzResourceGroup -Name $resourceGroupName -Location "$resourceGroupLocation"
    }
    else {
      Write-Output "resourceGroupLocation is not set."
      exit
    }
  } else {
    if (-not $parametersFile) {
      Write-Output "Parameters file parametersFile does not exists." 
    }
    else {
      if ($templateFile) {
        $DeploymentInputs = @{
          ResourceGroupName     = "$resourceGroupName"
          TemplateFile          = "$workspace/$templateFile"
          TemplateParameterFile = "$workspace/$parametersFile"
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