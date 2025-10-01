variable "identifier" {
  description = "The DB instance identifier"
  type        = string
  default = "pineapple-mysql"
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
  default = "music"
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

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}