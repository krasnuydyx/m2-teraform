# Network ACLs
resource "aws_network_acl" "nacl-public" {
	vpc_id = "${aws_vpc.mage-vpc.id}"
	subnet_ids = ["${aws_subnet.Public-1a.id}", "${aws_subnet.Public-1b.id}"]
	tags {
		Name = "mage-vpc-nacl-public"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
	}
	ingress = {
		protocol = "tcp"
		rule_no = 120
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 80
		to_port = 80
	}
	ingress = {
		protocol = "tcp"
		rule_no = 150
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 443
		to_port = 443
	}
	ingress = {
		protocol = "tcp"
		rule_no = 200
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 1024
		to_port = 65535
	}
	ingress = {
		protocol = "udp"
		rule_no = 201
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 1024
		to_port = 65535
	}
	ingress = {
		protocol = "tcp"
		rule_no = 220
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 53
		to_port = 53
	}
	ingress = {
		protocol = "udp"
		rule_no = 221
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 53
		to_port = 53
	}
	ingress = {
		protocol = "udp"
		rule_no = 240
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 500
		to_port = 500
	}
	ingress = {
		protocol = "tcp"
		rule_no = 300
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 22
		to_port = 22
	}
	egress = {
		protocol = "all"
		rule_no = 100
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 0
		to_port = 0
	}
}

resource "aws_network_acl" "nacl-private" {
	vpc_id = "${aws_vpc.mage-vpc.id}"
	subnet_ids = ["${aws_subnet.Private-1a.id}", "${aws_subnet.Private-1b.id}"]
	tags {
		Name = "mage-vpc-nacl-private"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
	}
	ingress = {
		protocol = "tcp"
		rule_no = 100
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 1024
		to_port = 65535
	}
	ingress = {
		protocol = "tcp"
		rule_no = 120
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 22
		to_port = 22
	}
	ingress = {
		protocol = "tcp"
		rule_no = 150
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 80
		to_port = 80
	}
	ingress = {
		protocol = "tcp"
		rule_no = 170
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 443
		to_port = 443
	}
	egress = {
		protocol = "all"
		rule_no = 100
		action = "allow"
		cidr_block =  "0.0.0.0/0"
		from_port = 0
		to_port = 0
	}
}
