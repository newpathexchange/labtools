variable "vpc_name" {
  description = "Name of the VPC"
  type = string
  default = "labvpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default = "10.54.0.0/16"
}

variable "vpc_subnets" {
  description = "List of subnets in the VPC"
  type = list(object({
      cidr_block = string
      availability_zone = string
  }))
}

