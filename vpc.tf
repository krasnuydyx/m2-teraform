#VPC
data "aws_availability_zones" "available" {}
resource "aws_vpc" "mage-vpc" {
    cidr_block = "172.29.29.0/24"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "mage-vpc"
        Application = "Magento"
        Environment = "TST"
        TechOwnerEmail = "your_email@your_domain"
    }
}
#Public Subnets
resource "aws_subnet" "Public-1a" {
    vpc_id = "${aws_vpc.mage-vpc.id}"
    cidr_block = "172.29.29.0/26"
    map_public_ip_on_launch = "true"
    #availability_zone = "us-west-1a"
	availability_zone = "${data.aws_availability_zones.available.names[0]}"
    tags {
        Name = "mage-vpc-PublicSubnet-AZ1"
        Application = "Magento"
        Environment = "TST"
        TechOwnerEmail = "your_email@your_domain"
    }
}
resource "aws_subnet" "Public-1b" {
    vpc_id = "${aws_vpc.mage-vpc.id}"
    cidr_block = "172.29.29.64/26"
    map_public_ip_on_launch = "true"
    #availability_zone = "us-west-1b"
	availability_zone = "${data.aws_availability_zones.available.names[1]}"
    tags {
        Name = "mage-vpc-PublicSubnet-AZ2"
        Application = "Magento"
        Environment = "TST"
        TechOwnerEmail = "your_email@your_domain"
    }
}
#Private Subnets
resource "aws_subnet" "Private-1a" {
    vpc_id = "${aws_vpc.mage-vpc.id}"
    cidr_block = "172.29.29.128/26"
    map_public_ip_on_launch = "false"
    #availability_zone = "us-west-1a"
	availability_zone = "${data.aws_availability_zones.available.names[0]}"
    tags {
        Name = "mage-vpc-PrivateSubnet-AZ1"
        Application = "Magento"
        Environment = "TST"
        TechOwnerEmail = "your_email@your_domain"
    }
}
resource "aws_subnet" "Private-1b" {
    vpc_id = "${aws_vpc.mage-vpc.id}"
    cidr_block = "172.29.29.192/26"
    map_public_ip_on_launch = "false"
	#availability_zone = "us-west-1b"
	availability_zone = "${data.aws_availability_zones.available.names[1]}"
    tags {
        Name = "mage-vpc-PrivateSubnet-AZ2"
        Application = "Magento"
        Environment = "TST"
        TechOwnerEmail = "your_email@your_domain"
    }
}
#Internet Gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.mage-vpc.id}"
    tags {
        Name = "mage-vpc-PublicSubnet-AZ1"
        Application = "Magento"
        Environment = "TST"
        TechOwnerEmail = "your_email@your_domain"
    }
}
# route tables
resource "aws_route_table" "public-route1" {
    vpc_id = "${aws_vpc.mage-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
    tags {
        Name = "mage-vpc-PublicSubnet-AZ1"
        Application = "Magento"
        Environment = "TST"
        TechOwnerEmail = "your_email@your_domain"
    }
}
resource "aws_route_table" "private-route-AZ1" {
    vpc_id = "${aws_vpc.mage-vpc.id}"
    tags {
        Name = "mage-vpc-PrivateSubnet-AZ1"
        Application = "Magento"
        Environment = "TST"
        TechOwnerEmail = "your_email@your_domain"
    }
    route {
	cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat01.id}"
    }
}
resource "aws_route_table" "private-route-AZ2" {
    vpc_id = "${aws_vpc.mage-vpc.id}"
    tags {
        Name = "mage-vpc-PrivateSubnet-AZ1"
        Application = "Magento"
        Environment = "TST"
        TechOwnerEmail = "your_email@your_domain"
    }
    route {
	cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat02.id}"
    }
}
# route associations
resource "aws_route_table_association" "public-1a" {
    subnet_id = "${aws_subnet.Public-1a.id}"
    route_table_id = "${aws_route_table.public-route1.id}"
}
resource "aws_route_table_association" "public-1b" {
    subnet_id = "${aws_subnet.Public-1b.id}"
    route_table_id = "${aws_route_table.public-route1.id}"
}
resource "aws_route_table_association" "private-1a" {
    subnet_id = "${aws_subnet.Private-1a.id}"
    route_table_id = "${aws_route_table.private-route-AZ1.id}"
}
resource "aws_route_table_association" "private-1b" {
    subnet_id = "${aws_subnet.Private-1b.id}"
    route_table_id = "${aws_route_table.private-route-AZ2.id}"
}
