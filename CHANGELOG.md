# Changelog

## v1.1.0

- Add the optional `force_destroy` variable (type `bool`, default `false`) and set it on the `aws_s3_bucket.assets` resource.

## v1.0.1

- Enable versioning on the assets bucket.
- Add a `Description` tag set to `Shared object storage assets bucket with versioning`.

## v1.0.0

- Create an S3 assets bucket named `${name_prefix}-${environment}-assets`.
