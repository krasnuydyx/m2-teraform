resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-net"
  address_space       = ["${var.vnet}"]
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.deftags
}
resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.subnet
  # will be deprecated in next version and only used in ansga
  network_security_group_id = azurerm_network_security_group.nsg.id
}
resource "azurerm_public_ip" "publicip" {
  name                = "${var.prefix}PublicIP"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label	  = var.prefix
  tags                = var.deftags
}
resource "azurerm_subnet_network_security_group_association" "snsga1" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
#resource "azurerm_network_interface" "nic" {
#  name                      = "${var.prefix}NIC"
#  location                  = var.region
#  resource_group_name       = azurerm_resource_group.rg.name
#  network_security_group_id = azurerm_network_security_group.nsg.id
#  tags                      = var.deftags
#  ip_configuration {
#    name                          = "${var.prefix}NICConfg"
#    subnet_id                     = azurerm_subnet.subnet.id
#    private_ip_address_allocation = "dynamic"
#    public_ip_address_id          = azurerm_public_ip.publicip.id
#  }
#}
resource "azurerm_lb" "lb" {
  name                = "${var.prefix}-lb"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "${var.prefix}-lbip"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}
resource "azurerm_lb_backend_address_pool" "lbbpool" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "BackEndAddressPool"
}
resource "azurerm_lb_nat_pool" "lbnatssh" {
  resource_group_name            = azurerm_resource_group.rg.name
  name                           = "lbnatssh"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50001
  frontend_port_end              = 50099
  backend_port                   = 22
  frontend_ip_configuration_name = "${var.prefix}-lbip"
}
resource "azurerm_lb_rule" "lbrule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  backend_address_pool_id		 = azurerm_lb_backend_address_pool.lbbpool.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  probe_id						 = azurerm_lb_probe.lbprobe.id
  frontend_ip_configuration_name = "${var.prefix}-lbip"
}
resource "azurerm_lb_probe" "lbprobe" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "tcp-probe"
  protocol            = "tcp"
  port                = 80
}
output "PublicIP" {
	value = azurerm_public_ip.publicip.fqdn
}