variable "description" {
  description = "The description of the security group rule"
  type        = string
}

variable "type" {
  description = "The rule type"
  type        = string
}

variable "from_port" {
  description = "The start port (or ICMP type number if protocol is 'icmp')"
  type        = number
}

variable "to_port" {
  description = "The end port (or ICMP code if protocol is 'icmp')"
  type        = number
}

variable "protocol" {
  description = "The protocol"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID"
  type        = string
}

variable "source_security_group_id" {
  description = "The source security group ID"
  type        = string
}

