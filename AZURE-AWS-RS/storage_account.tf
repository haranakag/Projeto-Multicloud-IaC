resource "azurerm_resource_group" "resource_group" {
  name     = "rg-terraform-state"
  location = var.location

  tags = local.commontags
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "haranakaterraformstate"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  versioning_enabled = true

  tags = local.commontags
}

resource "azurerm_storage_container" "container" {
  name                  = "remote-state"
  resource_group_name   = azurerm_resource_group.resource_group.name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}