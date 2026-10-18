# Changelog

## v1.0.2

- Add an `Owner` tag set to `platform` in `common_tags` (`main.tf`). The `Module` and `Description` tags are unchanged.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
