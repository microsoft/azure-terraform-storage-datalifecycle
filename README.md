# Terraform Script to create Storage Account , Containers and Data Lifecycle Rules at scale in Azure

With the wide scale adaptation of IAC, many a times we would need to create storage accounts and corresponding entities dynamically using IAC Scripts.

Here is an article which simplifies this job for Azure Cloud.

This is a utility kind template project, which is configuration driven, flexible and extensible.

This sample project will create storage accounts along with containers and the data lifecycle rules for the data.

Here is the list of items which would be created as part of the script:

* Storage Accounts
* Containers
* Data Lifecycle Rules

The script is flexible and scalable to accommodate any number of storage accounts, containers and data life cycle rules.

The script is configuration driven and based on a variable of type map(map(map))).

Sample variable format is shown below:

    "storage_account_container_config = {
        "StorageAccountName1" = {
            "Container1"       = { "LifeCycleAction1" : "NumberOfDays", "LifeCycleAction2" : "NumberOfDays"}
        }
        "StorageAccountName2" = {
            "Container2"       = { "LifeCycleAction1" : "NumberOfDays", "LifeCycleAction1" : "NumberOfDays" }
        }
        "StorageAccountName3" = {
            "Container3"       = { "LifeCycleAction1" : "NumberOfDays" }
            "Container4"       = {   }
        }
    }

* First level map represents storage accounts.

* Second level map represents the containers inside the respective storage account.

* Third level map represents the data life cycle rules under respective container.

Configure as many storage accounts, containers and lifecycle rules as needed and run the IAC script provided in this git repo.

Here are the sequence of commands to run the script:

* terraform init
* terraform plan
* terraform apply

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
