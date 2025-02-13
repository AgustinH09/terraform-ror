variable "cloudwatch_logs_retention_in_days" {
  description = "The number of days to retain log events in the log group."
  type        = number
  default     = 30
}

variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group."
  type        = string
}
