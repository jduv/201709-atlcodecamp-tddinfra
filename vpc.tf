// Central VPC for all things K2
resource "aws_vpc" "cc2017_vpc" {
  cidr_block           = "${var.primary_vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name    = "CodeCamp2017"
    BuiltBy = "Terraform"
  }
}

// Subnet for our compute cluster. Allows for segregation
// of compute resources. Nice for billing etc.
resource "aws_subnet" "cc2017_subnet" {
  vpc_id                  = "${aws_vpc.cc2017_vpc.id}"
  cidr_block              = "${var.web_cidr}"
  availability_zone       = "${var.web_az}"
  map_public_ip_on_launch = true

  tags {
    Name    = "CodeCamp2017"
    BuiltBy = "Terraform"
  }
}

// Internet gateway allowing EMR to talk to nodes
resource "aws_internet_gateway" "cc2017_igw" {
  vpc_id = "${aws_vpc.cc2017_vpc.id}"

  tags {
    Name = "cc2017-igw"
  }
}

resource "aws_route_table" "cc2017_rt" {
  vpc_id = "${aws_vpc.cc2017_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.cc2017_igw.id}"
  }
}

resource "aws_main_route_table_association" "cc2017_rta" {
  vpc_id         = "${aws_vpc.cc2017_vpc.id}"
  route_table_id = "${aws_route_table.cc2017_rt.id}"
}
