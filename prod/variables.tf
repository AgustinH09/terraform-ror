variable "bucket_name" {
  type        = string
  default     = ""
  description = "The name of the S3 bucket. If not provided, the name will be taken from config.json."
}

variable "file_source_dir" {
  type        = string
  default     = ""
  description = "The local directory from which files will be uploaded. If not provided, the directory will be taken from config.json."
}

variable "logging_bucket_name" {
  type        = string
  default     = ""
  description = "The name of the bucket to store S3 access logs. If not provided, the name will be taken from config.json."
}

variable "topic_name" {
  type        = string
  default     = ""
  description = "The name of the SNS topic."
}

variable "sns_tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the SNS topic."
}

variable "sns_subscriptions" {
  type = map(object({
    protocol = string
    endpoint = string
  }))
  default     = {}
  description = "A map of subscriptions to the SNS topic."
}

variable "web_service_file_source_dir" {
  type        = string
  default     = ""
  description = "The local directory from which files will be uploaded to the web service bucket. If not provided, the directory will be taken from config.json."
}

variable "secret_key_base" {
  type        = string
  default     = ""
  description = "The secret key base for the Rails application."
}

