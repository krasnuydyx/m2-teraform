# Terraform as code for AWS Magento Infrastructure

Pre requirements:
 - Terraform
 - Azure account, installed "az cli" and configured auth (az login)

This configs will deploy infrastructure, clone magento repo and run composer install
Allow five minutes after deployment for all steps to complete
Use config _variables.tf to edit variables


| | | |
| ------------- |:-------------:| -----:|
| Resource Group | mg-test | |
|CIDR Block| 10.9.8.0/24 | |
| Subnets |  10.9.8.0/27 | |
|Services| MySQL, Redis | |

You can disable redis by renaming file redis.tf to redis
