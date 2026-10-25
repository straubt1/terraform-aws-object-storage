# Changelog

## v1.1.0

- Add an optional `force_destroy` variable (`bool`, default `false`).
- Set `force_destroy` on the `aws_s3_bucket.assets` resource.
- Add an `aws_s3_bucket_public_access_block` that blocks public ACLs and policies on the assets bucket.
- Encrypt the assets bucket with SSE-KMS using a customer managed KMS key with rotation enabled.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
