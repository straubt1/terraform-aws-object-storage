# terraform-aws-object-storage v1.0.2

Creates an S3 assets bucket named `${name_prefix}-${environment}-assets-rename`.

Versioning is enabled on the bucket.

The bucket is tagged with `Name = demo-v2` and `Description = Shared networking assets bucket`.

## Inputs

| Name | Description | Default |
| --- | --- | --- |
| `name_prefix` | Prefix for resource names | `networking` |
| `environment` | Environment label applied to resources | `dev` |
| `tags` | Additional tags to apply to resources | `{}` |

## Outputs

| Name | Description |
| --- | --- |
| `bucket_id` | ID of the assets bucket |
| `bucket_arn` | ARN of the assets bucket |
