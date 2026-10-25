# Changelog

## v1.1.0

- Add an optional `force_destroy` variable (default `false`) to allow destroying the assets bucket when it contains objects.
- Set `force_destroy` on the `aws_s3_bucket.assets` resource from the new variable.
- Add an S3 public access block to the assets bucket.
- Encrypt the assets bucket with SSE-KMS using a customer managed KMS key.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
