output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.subnets.private_subnet_ids
}

output "rds_subnet_group_id" {
  value = aws_db_subnet_group.rds.id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_listener_port" {
  value = module.alb.listener_port
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group."
  value = module.ecs_logs.name
}

