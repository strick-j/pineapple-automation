variable "linux_instance_type" {
  description = "instance type to be deployed"
  type = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet where the instance will be deployed"
  type = string
}

variable "linux_security_group_ids" {
  description = "List of security group IDs to associate with the Linux instance"
  type = list(string)
}

variable "team_name" {
  description = "Name of the team for tagging purposes"
  type = string
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the instance"
  type        = string
}

variable "linux_hostname" {
  description = "Hostname for the Linux instance"
  type        = string
}

## Resource Tags
variable "asset_owner_name" {
  description = "Name of the human that the cloud team can contact with questions"
  type = string
}

variable "iScheduler" {
  description = "iScheduler tag value"
  type = string
}

variable "iCreator_CreatorBy" {
  description = "iCreator_CreatorBy tag value"
  type = string
}

variable "name" {
  description = "Name of the Linux instance"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "ec2_s3_ro_instance_profile_name" {
  description = "Name of the EC2 S3 read-only instance profile"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket containing the scripts"
  type        = string
}

variable "s3_bucket_path" {
  description = "Path within the S3 bucket where the scripts are located"
  type        = string
}

# SIA
variable "service_id" {
  description = "Service ID for SIA configuration"
  type        = string
}

variable "aws_role_name" {
  description = "AWS role name for the EC2 instance"
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

variable "platform_tenant_name" {
  description = "Platform tenant name for Identity Tenant (e.g. subdomain)"
  type        = string
}

variable "identity_tenant_id" {
  description = "Identity tenant ID for Identity Authentication (e.g. abc12345)"
  type        = string
}

variable "workspace_id" {
  description = "Workspace ID for SIA configuration"
  type        = string
}

variable "workspace_type" {
  description = "Workspace type for SIA configuration"
  type        = string
}