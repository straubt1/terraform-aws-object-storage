# Changelog

## v1.1.0

- Add an optional `force_destroy` variable (default `false`).
- Set `force_destroy` on the `aws_s3_bucket.assets` resource.
- Block all public access on the assets bucket with an `aws_s3_bucket_public_access_block`.
- Encrypt the assets bucket with SSE-KMS using a customer managed KMS key.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
