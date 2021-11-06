terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.25"
    }
  }
}

# Find the VPC
data "aws_vpc" "vpc" {
    tags = {
        Name = var.vpc_name
    }
}

# Get the subnet IDs
data "aws_subnet_ids" "vpc_subnets" {
  vpc_id = data.aws_vpc.vpc.id
}

# Security Group
resource "aws_security_group" "secgrp" {
    name_prefix = "${var.server_name}_sg"
    description = "Allow ports for ${var.server_name} cluster"
    vpc_id = data.aws_vpc.vpc.id
}

resource "aws_security_group_rule" "sg_ingress_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.app_cidr_block]
    security_group_id = aws_security_group.secgrp.id 
    description = "Allow inbound SSH"
}

resource "aws_security_group_rule" "sg_ingress_app" {
    type = "ingress"
    from_port = var.app_port_start
    to_port = var.app_port_end
    protocol = "tcp"
    cidr_blocks = [var.app_cidr_block]
    security_group_id = aws_security_group.secgrp.id 
    description = "Allow inbound app ports"
}

resource "aws_security_group_rule" "sg_egress_all" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.secgrp.id 
    description = "Allow all output"
}


# EC2
resource "aws_instance" "server_group" {
  count = var.server_count
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = [aws_security_group.secgrp.id]
  subnet_id = tolist(data.aws_subnet_ids.vpc_subnets.ids)[count.index % length(tolist(data.aws_subnet_ids.vpc_subnets.ids))]
  tags = {
    Name = "${var.server_name}${count.index + var.server_offset}"
  }
}

output "ec2_dns_names" {
    value = [aws_instance.server_group.*.public_dns]
}