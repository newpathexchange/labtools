
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.25"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "labvpc" {
  cidr_block = "10.54.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "labvpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "lab_gw" {
  vpc_id = aws_vpc.labvpc.id

  tags = {
    Network = "Public"
    Name = "labvpc-igw"
  }
}

# Subnets
resource "aws_subnet" "public0" {
  vpc_id = aws_vpc.labvpc.id
  cidr_block = "10.54.14.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Network = "Public"
    Name = "labvpc-public-us-east-1a"
  }
}

resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.labvpc.id
  cidr_block = "10.54.16.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Network = "Public"
    Name = "labvpc-public-us-east-1b"
  }
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.labvpc.id
  cidr_block = "10.54.24.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = "true"

  tags = {
    Network = "Public"
    Name = "labvpc-public-us-east-1c"
  }
}

# Internet Route
resource "aws_route" "internet_route" {
  route_table_id = aws_vpc.labvpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.lab_gw.id
}

# Subnet Associations to Route Table
resource "aws_route_table_association" "srta0" {
  subnet_id = aws_subnet.public0.id
  route_table_id = aws_vpc.labvpc.default_route_table_id
}

resource "aws_route_table_association" "srta1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_vpc.labvpc.default_route_table_id
}

resource "aws_route_table_association" "srta2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_vpc.labvpc.default_route_table_id
}
