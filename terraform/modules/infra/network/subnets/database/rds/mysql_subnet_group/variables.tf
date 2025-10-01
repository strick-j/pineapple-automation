variable "team_name" {
  description = "Name prefix for tagging and naming"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "asset_owner_name" {
  description = "Name of the asset owner for tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}