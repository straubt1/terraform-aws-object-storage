# Changelog

## v1.0.2

- Rename the assets bucket to `${name_prefix}-${environment}-assets-rename`.
- Add an S3 public access block to the assets bucket with all four protections enabled.
- Encrypt the assets bucket with SSE-KMS using a customer managed KMS key.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
