
resource "null_resource" "push" {
  triggers = {
    image_tag          = var.image_tag
    ecr_repository_url = var.ecr_repository_url
  }

  provisioner "local-exec" {
    command = <<EOT
aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.ecr_repository_url}
docker tag ${var.image_tag} ${var.ecr_repository_url}:latest
docker push ${var.ecr_repository_url}:latest
EOT
  }
}

