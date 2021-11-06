
provider "aws" {
  region = "us-east-1"
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

module "my_server_group" {
  source = "../modules/aws-server-group"

  vpc_name = "labvpc"

  server_name = "mongo"
  server_count = 3

  ami_id = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "npxlab"

  app_port_start = 27017
  app_port_end = 27017
  app_cidr_block = "0.0.0.0/0"

}

output "ec2_dns_names" {
    value = [module.my_server_group.ec2_dns_names]  
}
