
# General variables used in all modules
variable "region" {
  description = "AWS cloud region for the deployment"
  default = "us-east-2"
  type = string
}

variable "team_name" {
  description = "cloud naming identifier"
  type = string
}

## Tag variables
variable "iScheduler" {
  description = "Identifier for the iScheduler environment"
  type        = string
}

variable "asset_owner_name" {
  description = "Name of the human that the cloud team can contact with questions"
  type = string
}

# Networking specific variables
variable "private_subnet_az" {
  description = "AWS identifier for the private subnet AZ"
  default = "us-east-2b"
  type = string
}

variable "public_subnet_az" {
  description = "AWS identifier for the public subnet AZ"
  default = "us-east-2a"
  type = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for your public subnet"
  type = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for your private subnet"
  type = string
}

variable "trusted_ips" {
  description = "List of trusted IPs for security group rules"
  type        = list(string)
}

variable "connector_pool_name" {
  description = "Name of the CyberArk SIA connector pool"
  type        = string
}

variable "workspace_type" {
  description = "CSP identifier. AWS, Azure, or GCP""
  type        = string
}

variable "identity_tenant_id" {
  description = "your cyberark tenant id. Example: 'https://abc1234.id.cyberark.cloud' woud be abc1234"
  type        = string
}

variable "platform_tenant_name" {
  description = "name of your cyberark tenant. Example: 'https://acme.cyberark.cloud' would be acme"
  type        = string
}
