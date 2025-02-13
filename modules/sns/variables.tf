variable "topic_name" {
  description = "The name of the SNS topic"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "subscriptions" {
  description = "A map of subscriptions to the topic."
  type = map(object({
    protocol = string
    endpoint = string
  }))
  default = {}
}
