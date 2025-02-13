
variable "vpc_id" {
  description = "The VPC ID in which the security group will be created."
  type        = string
}

variable "sg_name" {
  description = "The name of the security group."
  type        = string
  default     = "general-security-group"
}

variable "description" {
  description = "A description of the security group."
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group."
  type = list(object({
    description      = optional(string, "")
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules for the security group."
  type = list(object({
    description      = optional(string, "")
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
  }))
  default = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  ]
}

variable "tags" {
  description = "A map of tags to assign to the security group."
  type        = map(string)
  default     = {}
}

