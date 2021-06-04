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

# Find the VPC
data "aws_vpc" "labvpc" {
    tags = {
        Name = "labvpc"
    }
}

# Get the subnet IDs
data "aws_subnet_ids" "labvpc_subnets" {
  vpc_id = data.aws_vpc.labvpc.id
}

# Latest Ubuntu 20.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Security Group
resource "aws_security_group" "mongo_sg" {
    name_prefix = "mongo_sg"
    description = "Allow ports for MongoDB cluster"
    vpc_id = data.aws_vpc.labvpc.id
}

resource "aws_security_group_rule" "mongo_sg_ingress_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.mongo_sg.id 
    description = "Allow inbound SSH from anywhere"
}

resource "aws_security_group_rule" "mongo_sg_ingress_mongo" {
    type = "ingress"
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.mongo_sg.id 
    description = "Allow inbound MongoDB port from anywhere"
}

resource "aws_security_group_rule" "mongo_sg_egress_all" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.mongo_sg.id 
    description = "Allow all output"
}


# EC2
resource "aws_instance" "mongo_cluster" {
  count = 3
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "npxlab"
  security_groups = [aws_security_group.mongo_sg.id]
  subnet_id = tolist(data.aws_subnet_ids.labvpc_subnets.ids)[count.index]
  tags = {
    Name = "mongo${count.index}"
  }
}

output "ec2_dns_names" {
    value = [aws_instance.mongo_cluster.*.public_dns]
}