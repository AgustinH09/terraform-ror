
output "repository_arn" {
  description = "The ARN of the ECR repository."
  value       = aws_ecr_repository.ecr.arn
}

output "repository_url" {
  description = "The URL of the ECR repository."
  value       = aws_ecr_repository.ecr.repository_url
}

output "repository_name" {
  description = "The name of the ECR repository."
  value       = aws_ecr_repository.ecr.name
}

output "repository_registry_id" {
  description = "The registry ID associated with the ECR repository."
  value       = aws_ecr_repository.ecr.registry_id
}

