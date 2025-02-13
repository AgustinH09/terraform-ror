
resource "aws_ecr_repository" "ecr" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete
  tags                 = var.tags

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count      = var.lifecycle_policy != "" ? 1 : 0
  repository = aws_ecr_repository.ecr.name
  policy     = var.lifecycle_policy
}

