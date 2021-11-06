
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.25"
    }
  }
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Network = "Public"
    Name = "${var.vpc_name}-igw"
  }
}

# Subnets
resource "aws_subnet" "public" {
  count = length(var.vpc_subnets)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.vpc_subnets[count.index].cidr_block
  availability_zone = var.vpc_subnets[count.index].availability_zone
  map_public_ip_on_launch = "true"

  tags = {
    Network = "Public"
    Name = "${var.vpc_name}-public-${var.vpc_subnets[count.index].availability_zone}"
  }
}

# Internet Route
resource "aws_route" "internet_route" {
  route_table_id = aws_vpc.vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

# Subnet Associations to Route Table
resource "aws_route_table_association" "srta" {
  count = length(var.vpc_subnets)

  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_vpc.vpc.default_route_table_id 
}

