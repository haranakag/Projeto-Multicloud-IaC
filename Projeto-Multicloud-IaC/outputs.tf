output "storage_account_id" {
  description = "The ID of the Azure Storage Account."
  value       = azurerm_storage_account.storage_account.id
}

output "sa_primary_access_key" {
  description = "Primary Access Key da storage account criada na azure"
  value       = azurerm_storage_account.storage_account.primary_access_key
  sensitive   = true
}
