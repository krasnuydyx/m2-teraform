# EIPs
resource "aws_eip" "eip-nat01" {
	vpc = true
	tags {
		Name = "mage-vpc-eip-nat01"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
  }
}
resource "aws_eip" "eip-nat02" {
	vpc = true
	tags {
		Name = "mage-vpc-eip-nat02"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
  }
}
# NAT GW
resource "aws_nat_gateway" "nat01" {
	allocation_id = "${aws_eip.eip-nat01.id}"
	subnet_id     = "${aws_subnet.Public-1a.id}"
	depends_on = ["aws_internet_gateway.gw"]
	tags {
		Name = "mage-vpc-nat-gw-az1"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
  }
}
resource "aws_nat_gateway" "nat02" {
	allocation_id = "${aws_eip.eip-nat02.id}"
	subnet_id     = "${aws_subnet.Public-1b.id}"
	depends_on = ["aws_internet_gateway.gw"]
	tags {
		Name = "mage-vpc-nat-gw-az2"
		Application = "Magento"
		Environment = "TST"
		TechOwnerEmail = "your_email@your_domain"
  }
}