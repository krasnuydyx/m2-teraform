resource "azurerm_mysql_server" "ms" {
  name                = "${var.prefix}-db"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "B_Gen5_2"
    capacity = 2
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = var.dbuser
  administrator_login_password = var.dbpass
  version                      = "5.7"
  ssl_enforcement              = "Enabled"
}

output "database_conection" {
	value = azurerm_mysql_server.ms.fqdn
}
output "database_login" {
	value = var.dbuser
}
output "database_password" {
	value = var.dbpass
}