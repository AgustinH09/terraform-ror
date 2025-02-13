output "pushed_image_uri" {
  description = "The full URI of the pushed Docker image (tagged as latest)."
  value       = "${var.ecr_repository_url}:latest"
}

