provider "aws" {
  shared_credentials_file = "$file(var.aws_creds_path)"
  profile                 = "master"
  region = var.aws_region
}

