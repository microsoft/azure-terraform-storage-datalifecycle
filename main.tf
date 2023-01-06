terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.22.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

locals {

  # 1st for loop takes storage accounts
  # 2nd for loop takes containers from the storage account selected in first for loop and prepares a map of
  # key -> storage account name - container name
  # value -> container name

  container_config = merge([
    for storage_account, containers in var.storage_account_container_config : {
      for containername, container_lifecycle_config in containers :
      join("", ["${storage_account}", "-${containername}"]) => containername
    }
  ]...)

  blob_type_blockblob      = "blockBlob"
  lifecycle_action_cool    = "cool"
  lifecycle_action_archive = "archive"
  lifecycle_action_delete  = "delete"
}
# Looping and creating multiple stoarge accounts based on the 
# keys and values of var.storage_account_map

resource "azurerm_storage_account" "storage_account" {
  for_each                 = var.storage_account_container_config
  name                     = "${each.key}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  is_hns_enabled           = var.is_hns_enabled
  nfsv3_enabled            = false
  
  blob_properties {
    last_access_time_enabled = var.last_access_time_enabled
  }
}


resource "azurerm_resource_group_template_deployment" "storage-containers" {
  for_each            = local.container_config
  name                = each.value
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  depends_on = [
    azurerm_storage_account.storage_account
  ]

  parameters_content = jsonencode({
    "location"             = { value = var.location }
    "storageAccountName"   = { value = split("-", "${each.key}")[0] }
    "defaultContainerName" = { value = "${each.value}" }
  })

  template_content = file("${path.module}/storage-container.json")
}


locals {
  storage_name_id_map = zipmap(values(azurerm_storage_account.storage_account)[*].name, values(azurerm_storage_account.storage_account)[*].id)
}


resource "azurerm_storage_management_policy" "lifecycle" {
  for_each           = var.storage_account_container_config
  storage_account_id = local.storage_name_id_map[split(":", "${each.key}")[0]]
  dynamic "rule" {
    for_each = { for key, value in "${each.value}" : key => value if can(value[local.lifecycle_action_cool]) }
    content {
      name    = join("",[rule.key,local.lifecycle_action_cool])
      enabled = true
      filters {
        prefix_match = [rule.key]
        blob_types   = [local.blob_type_blockblob]
      }
      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than = rule.value[local.lifecycle_action_cool]
        }
      }
    }
  }
  dynamic "rule" {
    for_each = { for key, value in "${each.value}" : key => value if can(value[local.lifecycle_action_archive]) }
    content {
      name    = join("",[rule.key,local.lifecycle_action_archive])
      enabled = true
      filters {
        prefix_match = [rule.key]
        blob_types   = [local.blob_type_blockblob]
      }
      actions {
        base_blob {
          tier_to_archive_after_days_since_modification_greater_than = rule.value[local.lifecycle_action_archive]
        }
      }
    }
  }
  dynamic "rule" {
    for_each = { for key, value in "${each.value}" : key => value if can(value[local.lifecycle_action_delete]) }
    content {
      name    = join("",[rule.key,local.lifecycle_action_delete])
      enabled = true
      filters {
        prefix_match = [rule.key]
        blob_types   = [local.blob_type_blockblob]
      }
      actions {
        base_blob {
          delete_after_days_since_modification_greater_than = rule.value[local.lifecycle_action_delete]
        }
      }
    }
  }
}
