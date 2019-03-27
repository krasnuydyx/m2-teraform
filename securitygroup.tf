# mage-vpc-sg-elb
resource "aws_security_group" "sg-elb" {
	vpc_id = "${aws_vpc.mage-vpc.id}"
	name = "mage-vpc-sg-elb"
	tags {
		Name = "mage-vpc-sg-elb"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
	}
}
resource "aws_security_group_rule" "allow_80" {
	type = "ingress"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-elb.id}"
}
resource "aws_security_group_rule" "allow_443" {
	type = "ingress"
	from_port = 443
	to_port = 443
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-elb.id}"
}
resource "aws_security_group_rule" "allow_out_elb" {
	type = "egress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-elb.id}"
}

# mage-vpc-sg-elb-ephemeral
resource "aws_security_group" "sg-elb-ephemeral" {
	vpc_id = "${aws_vpc.mage-vpc.id}"
	name = "mage-vpc-sg-elb-ephemeral"
	tags {
		Name = "mage-vpc-sg-elb-ephemeral"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
	}
}
resource "aws_security_group_rule" "allow_tcp1024" {
	type = "ingress"
	from_port = 1024
	to_port = 65535
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-elb-ephemeral.id}"
}
resource "aws_security_group_rule" "allow_udp1024" {
	type = "ingress"
	from_port = 1024
	to_port = 65535
	protocol = "udp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-elb-ephemeral.id}"
}
resource "aws_security_group_rule" "allow_out_elb_eph" {
	type = "egress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-elb-ephemeral.id}"
}

# mage-vpc-sg-ephemeral
resource "aws_security_group" "sg-ephemeral" {
	vpc_id = "${aws_vpc.mage-vpc.id}"
	name = "mage-vpc-sg-ephemeral"
	tags {
		Name = "mage-vpc-sg-ephemeral"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
	}
}
resource "aws_security_group_rule" "allow_tcp32768" {
	type = "ingress"
	from_port = 32768
	to_port = 65535
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-ephemeral.id}"
}
resource "aws_security_group_rule" "allow_udp32768" {
	type = "ingress"
	from_port = 32768
	to_port = 65535
	protocol = "udp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-ephemeral.id}"
}
resource "aws_security_group_rule" "allow_out_eph" {
	type = "egress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-ephemeral.id}"
}

# mage-vpc-sg-web
resource "aws_security_group" "sg-web" {
	vpc_id = "${aws_vpc.mage-vpc.id}"
	name = "mage-vpc-sg-web"
	tags {
		Name = "mage-vpc-sg-web"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
	}
}
resource "aws_security_group_rule" "web80-01" {
	type = "ingress"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-web.id}"
}
resource "aws_security_group_rule" "web443-01" {
	type = "ingress"
	from_port = 443
	to_port = 443
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-web.id}"
}
resource "aws_security_group_rule" "allow_out_web" {
	type = "egress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-web.id}"
}

# mage-vpc-sg-ssh
resource "aws_security_group" "sg-ssh" {
	vpc_id = "${aws_vpc.mage-vpc.id}"
	name = "mage-vpc-sg-ssh"
	tags {
		Name = "mage-vpc-sg-ssh"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
	}
}
resource "aws_security_group_rule" "ssh-01" {
	type = "ingress"
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-ssh.id}"
}
resource "aws_security_group_rule" "allow_out_ssh" {
	type = "egress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.sg-ssh.id}"
}

# mage-vpc-sg-rds
resource "aws_security_group" "sg-rds" {
	vpc_id = "${aws_vpc.mage-vpc.id}"
	name = "mage-vpc-sg-rds"
	tags {
		Name = "mage-vpc-sg-rds"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
	}
}
resource "aws_security_group_rule" "rds-01" {
	type = "ingress"
	from_port = 3306
	to_port = 3306
	protocol = "tcp"
	cidr_blocks = ["172.29.29.128/26", "172.29.29.192/26"]
	security_group_id = "${aws_security_group.sg-rds.id}"
}
resource "aws_security_group_rule" "allow_out_rds" {
	type = "egress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["172.29.29.128/26", "172.29.29.192/26"]
	security_group_id = "${aws_security_group.sg-rds.id}"
}

# mage-vpc-sg-redis
resource "aws_security_group" "sg-redis" {
	vpc_id = "${aws_vpc.mage-vpc.id}"
	name = "mage-vpc-sg-redis"
	tags {
		Name = "mage-vpc-sg-redis"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
	}
}
resource "aws_security_group_rule" "redis-01" {
	type = "ingress"
	from_port = 6379
	to_port = 6379
	protocol = "tcp"
	cidr_blocks = ["172.29.29.128/26", "172.29.29.192/26"]
	security_group_id = "${aws_security_group.sg-redis.id}"
	description = "VPC Access"
}
resource "aws_security_group_rule" "allow_out_redis" {
	type = "egress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["172.29.29.128/26", "172.29.29.192/26"]
	security_group_id = "${aws_security_group.sg-redis.id}"
}
