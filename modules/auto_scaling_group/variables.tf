variable "vpc_id" {
  description = "The VPC ID in which ECS instances will be launched."
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs where ECS instances will be launched."
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired capacity for the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum size for the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size for the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster that these instances should join."
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to assign to the ECS container instances."
  type        = string
}

