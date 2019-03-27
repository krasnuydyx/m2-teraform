resource "aws_db_instance" "mage-vpc-db" {
	allocated_storage = 100
	storage_type = "gp2"
	engine = "mysql"
	engine_version = "5.7"
	instance_class = "db.t2.small"
	identifier = "rds-magento-${count.index}"
	name = "magento2"
	username = "magento2"
	password = "123123qa"
	parameter_group_name = "mage-vpc-rds-param"
	auto_minor_version_upgrade = true
	publicly_accessible = false
	backup_retention_period = 14
	backup_window = "00:00-02:00"
	maintenance_window = "Mon:02:00-Mon:04:00"
	port = 3306
	multi_az = true
	db_subnet_group_name = "mage-vpc-rds-subnetgroup"
	skip_final_snapshot = true
	vpc_security_group_ids = [ "${aws_security_group.sg-rds.id}" ]
    tags {
        Name = "mage-vpc-rds"
        Application = "Magento"
        Environment = "TST"
        TechOwnerEmail = "your_email@your_domain"
    }
}
resource "aws_db_instance" "mage-vpc-db-replica" {
	replicate_source_db = "${aws_db_instance.mage-vpc-db.identifier}"
	instance_class = "db.t2.small"
	allocated_storage = 100
	storage_type = "gp2"
	identifier = "rds-magento-replica${count.index}"
	auto_minor_version_upgrade = true
	publicly_accessible = false
	backup_retention_period = 14
	backup_window = "02:00-04:00"
	maintenance_window = "Mon:04:00-Mon:06:00"
	skip_final_snapshot = true
	parameter_group_name = "mage-vpc-rds-param"
    tags {
        Name = "mage-vpc-rds-repl"
        Application = "Magento"
        Environment = "TST"
        TechOwnerEmail = "your_email@your_domain"
    }
}
resource "aws_db_parameter_group" "mage-vpc-rds-param" {
	name   = "mage-vpc-rds-param"
	family = "mysql5.7"
	parameter {
		name = "log_bin_trust_function_creators"
		value = "1"
	}
}
resource "aws_db_subnet_group" "mage-vpc-rds-subnetgroup" {
	name = "mage-vpc-rds-subnetgroup"
	subnet_ids = ["${aws_subnet.Private-1a.id}", "${aws_subnet.Private-1b.id}"]
}
output "RDS address" {
	value = "${aws_db_instance.mage-vpc-db.endpoint}"
}
