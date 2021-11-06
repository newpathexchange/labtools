
provider "aws" {
  region = "us-east-1"
}

module "my_simple_vpc" {
  source = "../modules/aws-simple-vpc"

  vpc_name = "labvpc"
  vpc_cidr_block = "10.54.0.0/16"
  vpc_subnets = [
      {
          cidr_block = "10.54.14.0/24"
          availability_zone = "us-east-1a"
      },
      {
          cidr_block = "10.54.16.0/24"
          availability_zone = "us-east-1b"
      },
      {
          cidr_block = "10.54.24.0/24"
          availability_zone = "us-east-1c"
      }
  ]

}
