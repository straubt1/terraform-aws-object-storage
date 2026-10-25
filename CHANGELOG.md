# Changelog

## v1.1.0

- Add an optional `force_destroy` variable (default `false`).
- Pass `force_destroy` to the `aws_s3_bucket.assets` resource.
- Block all public access on the assets bucket with an S3 public access block.
- Encrypt the assets bucket with SSE-KMS using a customer managed KMS key.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
