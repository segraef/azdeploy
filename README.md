# GitHub Action for Managing Azure Resources

This action can be used to create or update a resource group in Azure using the [Azure Resource Manager templates](https://azure.microsoft.com/en-in/documentation/articles/resource-group-template-deploy/)
One can also use this to delete a resource group, including all the resources within the resource group.

To log into a Azure, I recommend using [azlogin](https://github.com/segraef/azlogin) Action.

## Usage

```

- uses: segraef/azdeploy@v1
  with:
    resourceGroupName: "rg-deploy"
    resourceGroupLocation: "westeurope"
    templateFile: "deploy.json"
    parametersFile: "parameters.json"

```

### Environment variables

- `resourceGroupCommand` – **Optional**.

  - If `resourceGroupCommand` is not specified or is "create"
    - `resourceGroupName` – **Mandatory**
    - `resourceGroupLocation` – **Mandatory**
    - `templateFile` – **Mandatory** - Relative path in your github repository. URL is in progress.
    - `parametersFile` – **Mandatory** - Relative path in your github repository. URL is in progress.
    
  -  If `resourceGroupCommand` is "delete"
     - `resourceGroupName` – **Mandatory**