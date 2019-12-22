resource "azurerm_storage_account" "magestacc" {
  name                     = "magest"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "magestsh" {
  name                 = "magesh"
  storage_account_name = azurerm_storage_account.magestacc.name
  quota                = 50
}

output "storage_share_name" {
	value = azurerm_storage_share.magestsh.name
}
output "storage_account_name" {
	value = azurerm_storage_account.magestacc.name
}
output "storage_primary_access_key" {
	value = azurerm_storage_account.magestacc.primary_access_key
}