variable "identifier" {
  description = "The DB instance identifier"
  type        = string
}

variable "instance_class" {
  description = "Instance type"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "DB storage in GB"
  type        = number
  default     = 10
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_subnet_group_name" {
  description = "DB subnet group"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether the DB is publicly accessible"
  type        = bool
  default     = false
}

variable "mysql_username" {
  description = "Conjur variable name for MySQL username"
  type        = string
}

variable "mysql_password" {
  description = "Conjur variable name for MySQL password"
  type        = string
}


# AWS asset tags for compliance
variable "iScheduler" {
  description = "Identifier for the iScheduler environment"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "iCreateor_CreatorBy" {
  description = "Identifier for the creator"
  type        = string
}
variable "asset_owner_name" {
  description = "Name of the human that the cloud team can contact with questions"
  type = string
}

variable "conjur_appliance_url" {
  description = "URL of the Conjur appliance"
  type        = string
}

variable "conjur_account" {
  description = "Conjur account name"
  type        = string
}

variable "conjur_authn_type" {
  description = "Conjur authentication type"
  type        = string
}

variable "conjur_authn_service_id" {
  description = "Conjur authentication service ID"
  type        = string
}

variable "conjur_host_id" {
  description = "Conjur host ID"
  type        = string
}
