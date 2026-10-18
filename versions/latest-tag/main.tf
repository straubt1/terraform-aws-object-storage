locals {
  bucket_name = "${var.name_prefix}-${var.environment}-assets"
  common_tags = merge(var.tags, {
    Module      = "terraform-aws-object-storage"
    Version     = "v1.0.1"
    Name        = "demo-v2"
    Description = "Shared object storage assets bucket"
    Owner       = "platform"
  })
}

resource "aws_s3_bucket" "assets" {
  bucket = local.bucket_name

  tags = local.common_tags
}

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}
