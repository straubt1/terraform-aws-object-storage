# Changelog

## v2.0.0

- Require `kms_key_id` and encrypt the assets bucket with that customer managed key. Configurations that omit it cannot apply.
- Block public ACLs and public bucket policies on the assets bucket.
- Add an `Owner` tag set to `platform`.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
