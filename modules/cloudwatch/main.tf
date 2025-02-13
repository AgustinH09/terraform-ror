resource "aws_cloudwatch_log_group" "log_group" {
  name = var.cloudwatch_log_group_name

  retention_in_days = var.cloudwatch_logs_retention_in_days
}
