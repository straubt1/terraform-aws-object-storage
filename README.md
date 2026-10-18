# terraform-aws-object-storage

Creates an S3 Bucket with versioning enabled.

## Tags

The module applies the following fixed tags to the bucket:

- `Module` = `terraform-aws-object-storage`
- `Description` = `Shared object storage assets bucket with versioning`
- `Owner` = `platform`

`common_tags` merges `var.tags` with these fixed tags.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_s3_bucket.assets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.assets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_environment"></a> [environment](#input\_environment) | Value interpolated into the bucket name as `${name_prefix}-${environment}-assets`. It is not applied as a tag or label. | `string` | `"dev"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix used to build the bucket name `${name_prefix}-${environment}-assets` | `string` | `"networking"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags merged with the fixed Module, Description, and Owner tags. The fixed keys take precedence over user-supplied keys with the same name. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the assets bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | ID of the assets bucket |
<!-- END_TF_DOCS -->
