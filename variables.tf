variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "networking"
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

variable "force_destroy" {
  description = "Whether to allow the bucket to be destroyed even if it contains objects."
  type        = bool
  default     = false
}
