resource "azurerm_virtual_machine_scale_set" "vmset" {
  name                = "${var.prefix}-vmset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  upgrade_policy_mode = "Manual"
  # required when using rolling upgrade policy
  #health_probe_id = azurerm_lb_probe.lbprobe.id
  sku {
    name     = var.vm_size
    tier     = "Standard"
    capacity = 1
  }
  storage_profile_image_reference {
  	publisher = var.vm_publisher
	offer = var.vm_offer
	sku = var.vm_sku
	version = var.vm_version
  }
  storage_profile_os_disk {
    #name              = "${var.prefix}OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }
#  storage_profile_data_disk {
#    lun           = 0
#    caching       = "ReadWrite"
#    create_option = "Empty"
#    disk_size_gb  = 10
#  }
  os_profile {
    computer_name_prefix = "${var.prefix}VMset"
    admin_username = var.user
    admin_password = var.pass
	custom_data = templatefile("cloud-init.cfg",
		{
			storagename = azurerm_storage_account.magestacc.name
			storagepath = azurerm_storage_share.magestsh.name
			storagepass = azurerm_storage_account.magestacc.primary_access_key
			mageurl = var.mageurl
			publicipfqdn = azurerm_public_ip.publicip.fqdn
		})
	#custom_data = "${data.cloudinit_config.config.rendered}"
	#custom_data = file("cloud-init.cfg")
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.user}/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }
  network_profile {
    name    = "vmset-scaleset-net-prof"
    primary = true
	network_security_group_id = azurerm_network_security_group.nsg.id
    ip_configuration {
      name                                   = "VMsetIPConf"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.lbbpool.id}"]
      load_balancer_inbound_nat_rules_ids    = ["${azurerm_lb_nat_pool.lbnatssh.id}"]
    }
  }
  tags = var.deftags
  depends_on = [azurerm_lb_rule.lbrule]
  boot_diagnostics {
	  enabled = true
	  storage_uri = azurerm_storage_account.magestacc.primary_blob_endpoint
  }
}