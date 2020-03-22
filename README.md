# GitHub Action for Managing Azure Resources

This action can be used to create or update a resource group in Azure using the [Azure Resource Manager templates](https://azure.microsoft.com/en-in/documentation/articles/resource-group-template-deploy/)
One can also use this to delete a resource group, including all the resources within the resource group.

To log into a Azure, I recommend using [azlogin](https://github.com/segraef/azlogin) Action.

## Usage

```

- uses: segraef/azdeploy@v1
  with:
    resourceGroupName: ${{ secrets.resourceGroupName }}
    templateFile: ${{ secrets.templateFile }}
    parametersFile: ${{ secrets.parametersFile }}
    resourceGroupCommand: ${{ secrets.resourceGroupCommand }}

```

### Environment variables

- `resourceGroupCommand` – **Optional**.

  - If `resourceGroupCommand` is not specified or is "create"
    - `resourceGroupName` – **Mandatory**
    - `templateFile` – **Mandatory** - Can be a URL or relative path in your github repository
    - `parametersFile` – **Mandatory** - Can be a URL or relative path in your github repository
    
  -  If `resourceGroupCommand` is "delete"
     - `resourceGroupName` – **Mandatory**