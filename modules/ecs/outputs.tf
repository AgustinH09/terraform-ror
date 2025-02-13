output "cluster_name" {
  description = "The name of the ECS Cluster."
  value       = aws_ecs_cluster.this.name
 }
output "ecs_cluster_id" {
  description = "The ID of the ECS Cluster."
  value       = aws_ecs_cluster.this.id
}

output "ecs_service_id" {
  description = "The ID of the ECS Service."
  value       = aws_ecs_service.this.id
}

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS Task Definition."
  value       = aws_ecs_task_definition.this.arn
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS Task Execution Role."
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "The ARN of the ECS Task Role."
  value       = aws_iam_role.ecs_task_role.arn
}

output "final_image_uri" {
  description = "The final Docker image URI used in the container definition."
  value       = local.final_image
}

