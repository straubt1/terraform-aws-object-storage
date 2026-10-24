locals {
  bucket_name = "${var.name_prefix}-${var.environment}-assets"
  common_tags = merge(var.tags, {
    Module = "terraform-aws-object-storage"
  })
}

resource "aws_s3_bucket" "assets" {
  bucket = local.bucket_name

  tags = local.common_tags
}
