variable "name" {
  description = "Name of the CloudWatch log group."
  type        = string
}

variable "retention_in_days" {
  description = "Number of days to retain logs."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to assign to the CloudWatch log group."
  type        = map(string)
  default     = {}
}

