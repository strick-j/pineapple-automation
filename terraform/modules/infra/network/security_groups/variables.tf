variable "team_name" {
  description = "The name of the team or project"
  type = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type = string
}

variable "trusted_ips" {}

variable "asset_owner_name" {}

variable "internal_subnets" {}

variable "private_subnet_cidr" {}

variable "public_subnet_cidr" {}