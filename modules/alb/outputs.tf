output "alb_dns_name" {
  value       = aws_lb.app_lb.dns_name
  description = "The DNS name of the Application Load Balancer"
}

output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "listener_port" {
  value = var.listener_port
}
