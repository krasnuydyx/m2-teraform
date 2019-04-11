# Terraform as code for AWS Magento Infrastructure

Software url: https://www.terraform.io
Magento Wiki: https://wiki.corp.magento.com/display/ECGX/Terraform+as+code+for+Magento+Infrastructure

This project use user_data with template_file to install magento app


| | | |
| ------------- |:-------------:| -----:|
| VPC | mage-vpc | |
|CIDR Block| 172.29.29.0/24 | |
| Subnets | Public1 172.29.29.0/26, Public2 172.29.29.64/26, Private1 172.29.29.128/26, Private2 172.29.29.192/26 | |
|Services| RDS, ElastiCache (Redis) | |
| SSL | Self Signed certificate generated for 10 days | |
