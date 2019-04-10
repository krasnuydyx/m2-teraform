/*variable "web_ami_id" {
  type = "string"
} */

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners	= ["amazon"]
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2"
    ]
  }
  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }
}

resource "aws_launch_configuration" "lc-web" {
  name_prefix          = "lc-web"
  image_id             = "${data.aws_ami.amazon-linux.id}"
  instance_type        = "t2.medium"
  key_name             = "${aws_key_pair.ssh-key.key_name}"
  security_groups      = ["${aws_security_group.sg-web.id}", "${aws_security_group.sg-ssh.id}", "${aws_security_group.sg-ephemeral.id}"]
  user_data = "${data.template_file.installation_template.rendered}"
  lifecycle { 
	create_before_destroy = true 
  }
  root_block_device {
    volume_size = "100"
  }
}

resource "aws_autoscaling_group" "asg-web" {
  name                 = "as-web"
  vpc_zone_identifier  = ["${aws_subnet.Private-1a.id}", "${aws_subnet.Private-1b.id}"]
  launch_configuration = "${aws_launch_configuration.lc-web.name}"
  min_size             = 1
  desired_capacity     = 1
  max_size             = 1
  health_check_grace_period = 300
  health_check_type = "ELB"
  target_group_arns = ["${aws_alb_target_group.alb-web-tg.arn}", "${aws_alb_target_group.alb-web-ssh-tg.arn}"]
  force_delete = true
  termination_policies = ["OldestLaunchConfiguration"]
  tag {
      key = "Name"
      value = "mage-web"
      propagate_at_launch = true
  }
  tag {
      key = "Application"
      value = "Magento"
      propagate_at_launch = true
  }
  tag {
      key = "TechOwnerEmail"
      value = "your_email@your_domain"
      propagate_at_launch = true
  }
  tag {
      key = "Environment"
      value = "TST"
      propagate_at_launch = true
  }
}

data "template_file" "installation_template" {
  template = "${file("app.tpl")}"

  vars {
    MAGE_MODE = "developer"

    MAGENTO_HOST_NAME = "${aws_alb.alb-web.dns_name}"
    MAGENTO_BASE_URL = "http://${aws_alb.alb-web.dns_name}/"

    MAGENTO_DATABASE_HOST = "${aws_db_instance.mage-vpc-db.endpoint}"
    MAGENTO_DATABASE_PORT = "${aws_db_instance.mage-vpc-db.port}"
    MAGENTO_DATABASE_NAME = "${aws_db_instance.mage-vpc-db.name}"
    MAGENTO_DATABASE_USER = "${aws_db_instance.mage-vpc-db.username}"
    MAGENTO_DATABASE_PASSWORD = "${aws_db_instance.mage-vpc-db.password}"

    MAGENTO_ADMIN_FRONTNAME = "${var.magento_admin_frontname}"

    MAGENTO_ADMIN_USER = "${var.magento_admin_user}"
    MAGENTO_ADMIN_PASSWORD = "${var.magento_admin_password}"
    MAGENTO_ADMIN_EMAIL = "${var.magento_admin_email}"
    MAGENTO_ADMIN_FIRSTNAME = "${var.magento_admin_firstname}"
    MAGENTO_ADMIN_LASTNAME = "${var.magento_admin_lastname}"

    MAGENTO_ADMIN_TIMEZONE = "${var.magento_admin_timezone }"
    MAGENTO_LOCALE = "${var.magento_locale}"

    GIT_REPOSITORY_URL = "${var.git-repository-url}"

    MAGENTO_REDIS_HOST_NAME = "${aws_elasticache_replication_group.mage-vpc-redis-rg.primary_endpoint_address}"
    MAGENTO_REDIS_PORT = "${aws_elasticache_replication_group.mage-vpc-redis-rg.port}"
  }
}

output "MAGENTO_BASE_URL" {
  value = "http://${aws_alb.alb-web.dns_name}/"
}
