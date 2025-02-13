variable "alb_name" {
  type        = string
  description = "The name of the Application Load Balancer"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the ALB will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs for the ALB"
}

variable "listener_port" {
  type        = number
  description = "The port on which the ALB listens"
}

variable "target_group_port" {
  type        = number
  description = "The port on which the target group receives traffic"
}
