# Changelog

## v1.0.2

- Add an `Owner = "platform"` tag to `common_tags`. The existing `Module` and `Description` tags are unchanged.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
- Tag the bucket with `Name = demo`.
