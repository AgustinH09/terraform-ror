provider "aws" {
  region  = local.config.aws_region
  profile = local.config.profile
}
