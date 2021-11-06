variable "vpc_name" {
  description = "Name of the VPC"
  type = string
  default = "labvpc"
}

variable "ami_id" {
  description = "AMI for servcer creation"
}

variable "instance_type" {
  description = "EC2 instance type for server"
  type = string
  default = "t3.micro"
}

variable "key_name" {
  description = "Existing key pair for server"
  type = string
}

variable "server_name" {
  description = "Server name prefix"
  type = string
}

variable "server_count" {
  description = "Start of port range for application access"
  type = number
  default = 1
}

variable "server_offset" {
  description = "Starting number for server names"
  type = number
  default = 0
}

variable "app_port_start" {
  description = "Start of port range for application access"
  type = number
  default = 0
}

variable "app_port_end" {
  description = "Start of port range for application access"
  type = number
  default = 0
}

variable "app_cidr_block" {
  description = "CIDR block for the application access"
  default = "0.0.0.0/0"
}


