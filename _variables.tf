variable "git-repository-url" {
  default = "https://github.com/magento/magento2.git"
  type = "string"
  description = ""
}

variable "ssh-public-key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzRUYCub7GaMuSJnW7lNZ9ryNf1q24MFb8cmHcVpPTGsGOGdtDjbLAdmrZXe0HSc9JqEj2cygzvsXAbI02sqscxdOtrPHVnRp4kGk6lBBxHCAeYnvFKnXSkc0kESZUlEc8upnY2+z6eX+xS3Kpz3Taimv1m1iDOpSn8XSwfktCK2FeGXOJNRmou1i2nfwa4bZq8wSzzrdetowdYdVxsiap7vDYIk6SoUs2Ot0TsXqctA7Os7TCRKJ26CWQZ1ao8gk8aZt98Du3jlvwOmkLi8/rwt30wCUbwuGmM1Dc0wkv5QgncCaKiaKtYAMUK1Y3Ne6OFu5ZvbuaHGidsK8GK5p3"
  type = "string"
  description = ""
}

variable "magento_admin_frontname" {
  type = "string"
  default = "admin"
  description = "Admin Access URL"
}

variable "magento_admin_user" {
  type = "string"
  default = "admin"
  description = "Admin Username"
}

variable "magento_admin_password" {
  type = "string"
  default = "admin123"
  description = "Admin Username"
}

variable "magento_admin_email" {
  type = "string"
  default = "admin@your-domain.com"
  description = "Admin E-Mail Address"
}

variable "magento_admin_firstname" {
  type = "string"
  default = "Admin"
  description = "Admin Firstname"
}

variable "magento_admin_lastname" {
  type = "string"
  default = "Admin"
  description = "Admin Lastname"
}

variable "magento_admin_timezone" {
  type = "string"
  default = "UTC"
  description = "Default Timezone"
}

variable "magento_locale" {
  type = "string"
  default = "en_US"
  description = "Default Localisation"
}
