resource_group_name       = "terraform"
location                  = "centralindia"
is_hns_enabled            = true
last_access_time_enabled  = true
blob_storage_cors_origins = ["https://*.contoso.com"]
bypass                    = ["AzureServices"]



storage_account_container_config = {
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





