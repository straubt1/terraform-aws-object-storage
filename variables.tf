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
