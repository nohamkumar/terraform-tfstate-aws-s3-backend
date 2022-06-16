/*
Purpose: S3 bucket, dyanmoDB table creation for .tfstate remote backend

Variable Inputs:
namespace (project name);
environment (ex: test/dev/prod); (add this only if stage/env is applicable)
*/

resource "aws_s3_bucket" "tfstate-bucket" {
  bucket = var.environment == "" ? local.bucket_name_noenv : local.bucket_name_env

  lifecycle {
    prevent_destroy = "true"
  }

  tags = {
    Environment = var.environment
    namespace   = var.namespace
  }
}

resource "aws_s3_bucket_acl" "backend-bucket-acl" {
  bucket = aws_s3_bucket.tfstate-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket-encryption" {
  bucket = aws_s3_bucket.tfstate-bucket.id
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "bucket-versioning" {
  bucket = aws_s3_bucket.tfstate-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.tfstate-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
