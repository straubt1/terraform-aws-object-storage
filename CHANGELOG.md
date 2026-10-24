# Changelog

## v1.0.2

- Rename the assets bucket suffix to `-assets-rename` by changing `bucket_name` in main.tf.
- Block public ACLs and public bucket policies with an S3 public access block.
- Encrypt the assets bucket with SSE-KMS using a customer managed KMS key.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
