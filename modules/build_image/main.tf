resource "null_resource" "build_image" {
  triggers = {
    dockerfile_path = var.dockerfile_path
    image_tag       = var.image_tag
  }

  provisioner "local-exec" {
    command = "docker build -t ${var.image_tag} ${var.dockerfile_path}"
  }
}

