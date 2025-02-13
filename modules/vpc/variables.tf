variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "vpc_tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the VPC."
}
