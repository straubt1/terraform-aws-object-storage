# Changelog

## v2.0.0

- Change the assets bucket name to `${name_prefix}-${environment}-assets-rename` in `main.tf`. This forces the primary S3 bucket to be recreated.
- Add an S3 public access block to the assets bucket.
- Encrypt the assets bucket with a customer managed KMS key (SSE-KMS).

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
