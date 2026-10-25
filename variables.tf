variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "bucket"
}

variable "environment" {
  description = "Environment label applied to resources"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "kms_key_id" {
  description = "ARN of the customer managed KMS key that encrypts the assets bucket"
  type        = string
}
