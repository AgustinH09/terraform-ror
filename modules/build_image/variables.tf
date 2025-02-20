variable "dockerfile_path" {
  description = "Path to the directory containing the Dockerfile."
  type        = string
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "database_url" {
  description = "URL of the database to connect to."
  type        = string
}

