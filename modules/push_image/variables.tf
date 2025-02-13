variable "aws_region" {
  description = "AWS region to use for ECR login."
  type        = string
}

variable "image_tag" {
  description = "The local Docker image tag to push"
  type        = string
}

variable "ecr_repository_url" {
  description = "The URL of the ECR repository"
  type        = string
}

