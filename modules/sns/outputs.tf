output "sns_topic_arn" {
  description = "The ARN of the SNS topic created"
  value       = aws_sns_topic.sns_topic.arn
}

output "sns_subscription_ids" {
  description = "The IDs of the SNS subscriptions"
  value       = { for k, v in aws_sns_topic_subscription.sns_subscription : k => v.id }
}
