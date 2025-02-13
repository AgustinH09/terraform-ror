output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

output "uploaded_files_urls" {
  value = [for obj in aws_s3_object.object : "https://${aws_s3_bucket.bucket.bucket}.s3.amazonaws.com/${obj.key}"]
}

output "website_url" {
  value = "http://${aws_s3_bucket.bucket.bucket}.s3-website-${data.aws_region.current.name}.amazonaws.com"
}

output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "access_key" {
  value = var.create_keys ? aws_iam_access_key.user_key[0].id : ""
}

output "secret_key" {
  value     = var.create_keys ? aws_iam_access_key.user_key[0].secret : ""
  sensitive = true
}

output "logging_bucket_name" {
  value = var.logging_bucket_name
}

output "is_logging_enabled" {
  value = var.logging_bucket_name != null && var.logging_bucket_name != ""
}
