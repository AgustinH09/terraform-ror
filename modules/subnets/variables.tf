variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where subnets will be created."
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "A list of CIDR blocks for public subnets."
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "A list of CIDR blocks for private subnets."
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of availability zones in which to create subnets."
}

variable "ipv6_cidr_block" {
  type        = string
  description = "The IPv6 CIDR block for the subnets"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = var.vpc_id
  tags = {
    Name = "Internet gateway"
  }
}
