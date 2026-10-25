# Changelog

## v2.0.0

- **Breaking:** Rename the assets bucket from `${name_prefix}-${environment}-assets` to `${name_prefix}-${environment}-assets-rename`. This forces the bucket to be recreated.
- Add an S3 public access block that blocks public ACLs and public policies, ignores public ACLs, and restricts public buckets.
- Encrypt the assets bucket with SSE-KMS using a new customer managed KMS key with rotation enabled.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
