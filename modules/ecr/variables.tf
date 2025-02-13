
variable "repository_name" {
  description = "The name of the ECR repository."
  type        = string
}

variable "image_tag_mutability" {
  description = "Tag mutability setting for the repository. Allowed values: MUTABLE or IMMUTABLE."
  type        = string
  default     = "MUTABLE"
}

variable "force_delete" {
  description = "If true, the repository will be forcefully deleted even if it contains images."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the repository."
  type        = map(string)
  default     = {}
}

variable "scan_on_push" {
  description = "If true, images are scanned for vulnerabilities immediately after being pushed."
  type        = bool
  default     = false
}

variable "lifecycle_policy" {
  description = "A JSON-formatted lifecycle policy for the repository. Leave as an empty string to disable."
  type        = string
  default     = ""
}

