output "asg_name" {
  description = "The name of the Auto Scaling Group for ECS instances."
  value       = aws_autoscaling_group.ecs_asg.name
}

