output "name" {
  description = "The name of the CloudWatch log group."
  value       = aws_cloudwatch_log_group.this.name
}

