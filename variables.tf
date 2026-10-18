variable "name_prefix" {
  description = "Prefix used to build the bucket name `${name_prefix}-${environment}-assets`"
  type        = string
  default     = "networking"
}

variable "environment" {
  description = "Value interpolated into the bucket name as `${name_prefix}-${environment}-assets`. It is not applied as a tag or label."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags merged with the fixed Module, Description, and Owner tags. The fixed keys take precedence over user-supplied keys with the same name."
  type        = map(string)
  default     = {}
}
