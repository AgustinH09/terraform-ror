variable "dockerfile_path" {
  description = "Path to the directory containing the Dockerfile."
  type        = string
}

variable "image_tag" {
  type        = string
  default     = "latest"
}

