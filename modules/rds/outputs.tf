
output "db_instance_identifier" {
  description = "The identifier of the RDS DB instance."
  value       = aws_db_instance.instance.id
}

output "db_instance_arn" {
  description = "The ARN of the RDS DB instance."
  value       = aws_db_instance.instance.arn
}

output "db_endpoint" {
  description = "The connection endpoint for the RDS DB instance."
  value       = aws_db_instance.instance.endpoint
}

output "db_address" {
  description = "The DNS address of the RDS DB instance."
  value       = aws_db_instance.instance.address
}

output "db_port" {
  description = "The port on which the RDS DB instance accepts connections."
  value       = aws_db_instance.instance.port
}

