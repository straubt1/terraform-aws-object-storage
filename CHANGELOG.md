# Changelog

## v1.1.0

- Add the optional `force_destroy` variable (default `false`).
- Set `force_destroy` on the `aws_s3_bucket.assets` resource.
- Add an S3 public access block to the assets bucket with all four settings enabled.
- Encrypt the assets bucket with SSE-KMS using a customer managed KMS key with rotation enabled.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
