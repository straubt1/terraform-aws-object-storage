# Changelog

## v1.1.0

- Add the optional `force_destroy` variable (type bool, default `false`) to control whether the assets bucket can be destroyed while it still contains objects.
- Change `aws_s3_bucket.assets` to support the new `force_destroy` setting.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
