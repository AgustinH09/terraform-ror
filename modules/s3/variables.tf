variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "create_keys" {
  description = "Boolean to decide if access keys should be created"
  type        = bool
  default     = false
}

variable "upload_files" {
  description = "Boolean to decide if files should be uploaded"
  type        = bool
  default     = false
}

variable "enable_website" {
  description = "Boolean to configure the bucket as a website"
  type        = bool
  default     = false
}

variable "file_source_dir" {
  description = "The source directory from which to upload files"
  type        = string
  default     = "./files"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the bucket"
  default     = {}
}

variable "index_document" {
  type        = string
  default     = "index.html"
  description = "The S3 bucket website index document."
}

variable "error_document" {
  type        = string
  default     = "error.html"
  description = "The S3 bucket website error document."
}

variable "logging_bucket_name" {
  description = "The name of the bucket to store S3 access logs"
  type        = string
  default     = ""
}

variable "logging_dir" {
  description = "The directory in the logging bucket to store access logs"
  type        = string
  default     = ""
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "website_htmls_files" {
  description = "The list of HTML files to upload to the website bucket"
  type        = list(string)
  default     = []
}
