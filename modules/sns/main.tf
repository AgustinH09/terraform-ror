resource "aws_sns_topic" "sns_topic" {
  name = var.topic_name
  tags = var.tags
}

resource "aws_sns_topic_subscription" "sns_subscription" {
  for_each = var.subscriptions

  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}
