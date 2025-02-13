variable "aws_region" {
  description = "AWS region for resources and ECR login."
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS Cluster."
  type        = string
}

variable "service_name" {
  description = "Name of the ECS Service."
  type        = string
}

variable "desired_count" {
  description = "Desired number of tasks for the service."
  type        = number
  default     = 1
}

variable "task_family" {
  description = "Family name for the ECS task definition."
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memory for the task (in MiB)"
  type        = string
  default     = "512"
}

variable "container_name" {
  description = "Container name."
  type        = string
}

variable "container_cpu" {
  description = "CPU units allocated to the container (0 to use task allocation)."
  type        = number
  default     = 0
}

variable "container_memory" {
  description = "Memory (in MiB) allocated to the container."
  type        = number
  default     = 256
}

variable "container_port" {
  description = "Port number inside the container."
  type        = number
  default     = 80
}

variable "host_port" {
  description = "Port on the host to map to the container port."
  type        = number
  default     = 80
}

# Image Build and Push Options
variable "build_image" {
  description = "Set to true to build the Docker image."
  type        = bool
  default     = false
}

variable "push_image" {
  description = "Set to true to push the Docker image to ECR."
  type        = bool
  default     = false
}

variable "dockerfile_path" {
  description = "Path to the Dockerfile directory"
  type        = string
  default     = "./"
}

variable "image_tag" {
  description = "Local Docker image tag to use for build and push"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "image_uri" {
  description = "Fallback image URI if not building/pushing an image."
  type        = string
  default     = ""
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum healthy percent during deployment."
  type        = number
  default     = 50
}

variable "deployment_maximum_percent" {
  description = "Maximum percent during deployment."
  type        = number
  default     = 200
}

variable "rails_master_key" {
  description = "The Rails master key for decrypting credentials."
  type        = string
  sensitive   = true
}

variable "secret_key_base" {
  description = "The Rails secret key base used for session, cookies, and more."
  type        = string
  sensitive   = true
}

variable "database_url" {
  description = "The connection string for the database (e.g. RDS) to be used by the application."
  type        = string
  sensitive   = true
}

variable "alb_target_group_arn" {
  description = "The ARN of the target group to attach to the ECS service"
  type        = string
}

variable "log_group_name" {
  description = "The name of the CloudWatch log group."
  type        = string
}

