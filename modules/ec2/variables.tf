variable "ami_id" {
  description = "The Amazon Machine Image (AMI) ID that is used to launch the instance."
  type        = string
}

variable "instance_type" {
  description = "The type of the EC2 instance (e.g., t2.micro, m5.large) to determine the hardware of the host computer used for the instance."
  type        = string
}

variable "instance_name" {
  description = "The name given to the EC2 instance, used to label and identify the instance within the AWS environment."
  type        = string
}

variable "instance_count" {
  description = "The number of identical instances to launch from a single Terraform configuration."
  type        = number
}

variable "ssh_bucket" {
  description = "The name of the S3 bucket where SSH keys are stored for EC2 instance access."
}

variable "subnet_id" {
  description = "The ID of the subnet where the instance will be launched. This controls the networking layer for the instance."
  type        = string
}

variable "enable_ipv6" {
  description = "A boolean flag that indicates whether or not the instance should have IPv6 enabled."
  type        = bool
}

variable "vpc_id" {
  description = "The ID of the Virtual Private Cloud (VPC) where the instance and other resources are launched."
  type        = string
}


variable "security_group_rules" {
  description = "Security group rules for the EC2 instance."
  type = object({
    ingress : list(object({
      from_port : number
      to_port : number
      protocol : string
      cidr_blocks : list(string)
      ipv6_cidr_blocks : list(string)
    })),
    egress : list(object({
      from_port : number
      to_port : number
      protocol : string
      cidr_blocks : list(string)
      ipv6_cidr_blocks : list(string)
    }))
  })
}

variable "web_service_bucket" {
  description = "The S3 bucket where the web service files are stored."
}

variable "app_env_vars" {
  description = "Environment variables for the app"
  type        = map(string)
  default = {
    PORT = "80"
  }
}

variable "log_group_name" {
  description = "The name of the CloudWatch log group."
  type        = string
}

variable "use_load_balancer" {
  description = "A boolean flag that indicates whether or not the instance should be registered with a load balancer."
  type        = bool
  default     = false
}

variable "alb_target_group_arn" {
  description = "The ARN of the target group for the Application Load Balancer."
  type        = string
  default = ""
}

variable "alb_listener_port" {
  description = "The port on which the Application Load Balancer listens for incoming traffic."
  type        = number
  default     = 8080
}
