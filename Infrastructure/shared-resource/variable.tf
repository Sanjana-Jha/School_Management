variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "school"
}

variable "env" {
  description = "Environment prefix for resources"
  type        = string
  default     = "shared"
}

variable "location" {
  description = "Azure Region for resources"
  type        = string
  default     = "Central US"
}
