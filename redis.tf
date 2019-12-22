resource "azurerm_redis_cache" "redis" {
  name                = "${var.prefix}-redis"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  capacity            = 1
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {}
}

output "redis-address" {
	value = azurerm_redis_cache.redis.hostname
}
output "redis-port" {
	value = azurerm_redis_cache.redis.port
}
output "redis-key" {
	value = azurerm_redis_cache.redis.primary_access_key
}