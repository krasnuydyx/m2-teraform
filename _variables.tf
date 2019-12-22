variable "deftags" {
  type = map(string)
  default = {
    Environment = "Terraform test"
    Dept        = "Engineering"
  }
}

variable "mageurl" {
  type        = string
  default     = "https://github.com/magento/magento2.git"
  description = ""
}

variable "prefix" {
  type        = string
  default     = "mg-test"
  description = ""
}
variable "region" {
  type    = string
  default = "westus2"
  #default = "germanycentral"
  description = ""
}
variable "sku" {
  default = {
    westus2 = "7.5"
    #westus2 = "18.04-LTS"
    eastus = "18.04-LTS"
  }
}

variable "vm_publisher" {
	default = "OpenLogic"
	#default = "Canonical"
}
variable "vm_offer" {
	default = "CentOS-CI"
	#default = "UbuntuServer"
}
variable "vm_sku" {
	default = "7-CI"
	#default = "18.04-LTS"
	#default = var.sku[var.region]
}
variable "vm_version" {
	default = "latest"
	#default = "latest"
}
variable "vm_size" {
	default = "Standard_B1s"
}

variable "user" {
  type = string
  default = "madmin"
}
variable "pass" {
  type = string
  default = "M@123123q"
}

variable "dbuser" {
  type = string
  default = "mageadmin"
}
variable "dbpass" {
  type = string
  default = "M@123123q"
}

variable "safe_networks" {
	type = list
	default = ["68.170.69.178/32", "192.150.10.197/32", "74.213.232.233/32"]
}
variable "vnet" {
	type = string
	default = "10.9.8.0/24"
}
variable "subnet" {
	type = string
	default = "10.9.8.0/27"
}