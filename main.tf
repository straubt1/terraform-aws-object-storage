locals {
  bucket_name = "${var.name_prefix}-${var.environment}-assets"
  common_tags = merge(var.tags, {
    Module      = "terraform-aws-object-storage"
    Description = "Shared object storage assets bucket with versioning"
  })
}

resource "aws_kms_key" "assets" {
  description             = "Customer managed key for the ${local.bucket_name} bucket"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  tags = local.common_tags
}

resource "aws_s3_bucket" "assets" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets" {
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.assets.arn
    }
  }
}

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}
