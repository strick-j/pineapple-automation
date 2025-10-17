# General variables used in all modules
variable "aws_region" {
  description = "AWS cloud region for the deployment"
  type = string
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}

variable "team_name" {
  description = "cloud naming identifier"
  type = string
}

## Resource Tag variables
variable "iScheduler" {
  description = "Identifier for the iScheduler environment"
  type        = string
}

variable "iCreator_CreatorBy" {
  description = "Identifier for the creator"
  type        = string
}

variable "asset_owner_name" {
  description = "Name of the human that the cloud team can contact with questions"
  type = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "dc1_private_ip" {
  description = "Private IP address of the primary domain controller"
  type        = string
}

variable "allowed_ips" {
  description = "List of allowed Ips for ACLS"
  type        = list(string)
}

# Networking specific variables
variable "private_subnet_az" {
  description = "AWS identifier for the private subnet AZ"
  type = string
}

variable "public_subnet_az" {
  description = "AWS identifier for the public subnet AZ"
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

## Compute Variables
variable "linux_instance_type" {
  description = "Instance type for the Linux target"
  type        = string
}

variable "linux_hostname" {
  description = "Hostname for the Linux instance"
  type        = string
}

# CyberArk variables
## SIA specific variables
variable "connector_pool_name" {
  description = "Name of the CyberArk SIA connector pool"
  type        = string
}

variable "workspace_type" {
  description = "CSP identifier. AWS, Azure, or GCP"
  type        = string
}

## ISPSS specific variables
variable "identity_tenant_id" {
  description = "your cyberark tenant id. Example: 'https://abc1234.id.cyberark.cloud' woud be abc1234"
  type        = string
}

variable "platform_tenant_name" {
  description = "name of your cyberark tenant. Example: 'https://acme.cyberark.cloud' would be acme"
  type        = string
}

variable "ubuntu_scripts_s3_bucket_path" {
  description = "Path within the S3 bucket where the scripts are located"
  type        = string
}

# SIA specific variables
variable "service_id" {
  description = "Service ID for SIA configuration"
  type        = string
}

variable "host_id" {
  description = "Host ID for Conjur Authentication configuration"
  type        = string
}

variable "username_variable" {
  description = "Username variable for Conjur retrieval"
  type        = string
}

variable "password_variable" {
  description = "Password variable for Conjur retrieval"
  type        = string
}

variable "workspace_id" {
  description = "Workspace ID for SIA configuration"
  type        = string
}