Param( 
  [string]$resourceGroupName,
  [string]$resourceGroupLocation,
  [string]$resourceGroupCommand,
  [string]$templateFile,
  [string]$parametersFile,
  [string]$templateUri,
  [string]$parametersUri
)

$context = Get-AzContext
if (!$context) {
  Write-Output "##########`nNo Azure context found! Please make sure azlogin has run before.`n##########"
  exit
} 

if (-not $resourceGroupName) {
  Write-Output "##########`nresourceGroupName is not set.`n##########"
  exit
}
Try {
  if ($resourceGroupCommand -and ($resourceGroupCommand -like "create")) {
    Write-Output "##########`nExecuting commands to create/update resource group $resourceGroupName ...`n"
    if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
      if ($resourceGroupLocation) {
        New-AzResourceGroup -Name $resourceGroupName -Location "$resourceGroupLocation" -Force
      }
    }
    if ($templateFile -and $parametersFile) {
      Write-Output "##########`nDeploying with templateFile and parametersFile in $resourceGroupName ...`n##########"
      Write-Output "templateFile: $templateFile"
      Write-Output "parametersFile: $parametersFile"
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
    elseif ($templateUri -and $parametersUri) {
      Write-Output "##########`nDeploying with templateUri and parametersUri in $resourceGroupName ...`n##########"
      Write-Output "templateUri: $templateUri"
      Write-Output "parametersUri: $parametersUri"
      $DeploymentInputs = @{
        Name                 = "$($env:GITHUB_WORKFLOW)-$($env:GITHUB_ACTOR)-$(Get-Date -Format yyyyMMddHHMMss)"
        ResourceGroupName    = "$resourceGroupName"
        TemplateUri          = "$templateUri"
        TemplateParameterUri = "$parametersUri"
        Mode                 = "Incremental"
        Verbose              = $true
        ErrorAction          = "Stop"
      }
    
      New-AzResourceGroupDeployment @DeploymentInputs
    }
    elseif ($templateUri -and $parametersFile) {
      Write-Output "##########`nDeploying with templateUri and parametersFile in $resourceGroupName ...`n##########"
      Write-Output "templateUri: $templateUri"
      Write-Output "parametersFile: $parametersFile"
      $DeploymentInputs = @{
        Name                  = "$($env:GITHUB_WORKFLOW)-$($env:GITHUB_ACTOR)-$(Get-Date -Format yyyyMMddHHMMss)"
        ResourceGroupName     = "$resourceGroupName"
        TemplateUri           = "$templateUri"
        TemplateParameterFile = "$parametersFile"
        Mode                  = "Incremental"
        Verbose               = $true
        ErrorAction           = "Stop"
      }
    
      New-AzResourceGroupDeployment @DeploymentInputs
    }
    else {
      Write-Output "##########`nTemplate or parameters file does not exist. ...`n##########"
    }
  }
  elseif ($resourceGroupCommand -like "delete") {
    Write-Output "resourceGroupCommand is set to 'delete'. Removing $resourceGroupName now. "
    Remove-AzResourceGroup -Name $resourceGroupName -Force
  }
  else {
    Write-Output "##########`nSomething went wrong ...`n##########"
  }
}
Catch {
  $_.Exception.Message
  $_.Exception.ItemName
  Throw
}