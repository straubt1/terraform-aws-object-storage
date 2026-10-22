# Changelog

## v2.0.0

- Rename the assets bucket suffix from `-assets` to `-assets-rename`. This replaces the existing bucket (breaking change).
- Add S3 public access block for the assets bucket.
- Encrypt the assets bucket with a customer managed KMS key (`kms_key_arn` input, required with no default; breaking change).
- Update README inputs, outputs, and tag scope.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
