# Infrastructure

If you'd prefer to use manage the creation of resources, you can manage it with [`terraform`](https://https://www.terraform.io/). It's also possible to just us the azure portal to manually create both the function app and the web app, but I find being able to completely build and destory from the command line easier to manage the uptime and usage for costly items.

### Requirements

- `terraform` v0.12
  - understand of how terrsform works will prevent any miss use or charges
- Azure Subscription (with one of the following)
  - [Service Principle](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html)
  - [Azure CLI & Login](https://www.terraform.io/docs/providers/azurerm/guides/azure_cli.html)
- Azure Resources:
  - Existing Cosmos DB and Resource Group
    - we'll use as the DB Account can take a long time to create/destroy

### Setup

- Instrument `.env` file by follwing info in [`.env_example`](./.env_example)
- Setup Authentication to Azure via Service Principle or Azure CLI
- Uncomment and supply variables in [`terrform.tfvars`](./terraform.tfvars)

#### Vars

The [variables.tf](./variables.tf) file declares all of the variables that `terraform` will use to generate infrastructure and will contain some default values and description of their use.

#### Init

`terraform init` will initialize (or download) any modules and providers, like Azure or AWS, locally. If you add any modules to the `main.tf` file, you'll need to re-run the command to pull in the changes. If you comment a module out and uncomment it later, you'll need to re-run the initialization

#### Validate

`terraform validate` will validate the variables and resources being generated and not create or plan against Azure, but only validate the required properties are present.

#### Plan

`terraform plan` will attempt to pull in from Azure any existing infrastructure, like the resource group and cosmosdb, and any previously created resources and generate what the changes would look like. Without outputting the result, the real changes can look different when moving to the `apply` stage

#### Apply

`terraform apply` will start the process to build out our infrastructure with one approval step from the user. Once this process starts, it _can_ take a long time to generate the resources; since we've used a previously generated CosmosDB Account, we will save a chunk of time; it can take ~7 minutes to create.

#### Destroy

`terraform destroy` will predicably destroy all the resources that we've created, but any previously created ones will persist; Like the `apply` process, this takes a few minutes to complete. This should generally be used if you don't want to keep paying for resources after you've completed the perf-testing or any other usage.

### ***Oh No***
So you've gone an broke something or some how borked your state file: No to worry, there is a reason for only a single `azurerm_resource_group` and not use anything already existing to deploy new resources. We'll just have to remove everything created by terraform and remove the state file locally.

##### Manual Cleanup

###### delete azure resource group
- navigate to the [portal](https://portal.azure.com) and find the resource group you've created and delete it; it will be shaped like **`${prefix}-rg`**

###### remove state files
- delete both `terraform.tfstate` and `terraform.tfstate.backup`

###### revert back 
- `git reset HEAD` to undo any file changes (not recoverable)