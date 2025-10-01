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

variable "iCreateor_CreatorBy" {
  description = "iCreateor_CreatorBy tag value"
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