## v1.0.2

### Changed

- The `bucket_name` local in `main.tf` now ends in `-assets-rename` instead of `-assets`.

### Impact

- The bucket name changes, so the S3 bucket will be replaced (destroyed and recreated) on the next apply. Any data in the old bucket must be migrated before applying, and consumers that reference the bucket by name must be updated.

<!-- Append the existing ## v1.0.1 and ## v1.0.0 sections below this line, unchanged. -->
