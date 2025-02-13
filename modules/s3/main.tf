data "aws_region" "current" {}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  dynamic "logging" {
    for_each = var.logging_bucket_name != null && var.logging_bucket_name != "" ? [1] : []
    content {
      target_bucket = var.logging_bucket_name
      target_prefix = var.logging_dir != null ? var.logging_dir : "log/"
    }
  }

  tags = {
    Name = "My S3 Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  count  = var.enable_website ? 0 : 1
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.public_access]
}

resource "aws_s3_bucket_website_configuration" "website" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = var.index_document
  }
  error_document {
    key = var.error_document
  }
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:GetObject"]
        Effect    = "Allow",
        Resource  = ["${aws_s3_bucket.bucket.arn}/*"],
        Principal = "*"
      },
    ]
  })

  depends_on = [aws_s3_bucket_website_configuration.website, aws_s3_bucket_public_access_block.public_access]
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_access_key" "user_key" {
  count = var.create_keys ? 1 : 0
  user  = aws_iam_user.user[0].name
}

resource "aws_iam_user" "user" {
  count = var.create_keys ? 1 : 0
  name  = "${var.bucket_name}-user"
}

resource "aws_s3_object" "object" {
  for_each = var.upload_files ? fileset(var.file_source_dir, "**/*") : toset([])
  bucket   = aws_s3_bucket.bucket.id
  key      = each.value
  source   = "${var.file_source_dir}/${each.value}"
  etag     = filemd5("${var.file_source_dir}/${each.value}")

  depends_on = [aws_s3_bucket_public_access_block.public_access]
}
