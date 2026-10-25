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
  description = "Whether to delete all objects from the assets bucket when it is destroyed, so destroy does not fail on a non-empty bucket"
  type        = bool
  default     = false
}
