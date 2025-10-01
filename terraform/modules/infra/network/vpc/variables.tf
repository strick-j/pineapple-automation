variable "asset_owner_name" {
  description = "Name of the asset owner for tagging"
  type = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type = string
}

variable "region" {
  description = "AWS cloud region for the deployment" 
  type = string
}

variable "team_name" {
  description = "Name of the team for tagging purposes"
  type = string
}

variable "private_subnet_az" {
  description = "AWS identifier for the private subnet AZ"
  type = string
}

variable "public_subnet_az" {
  description = "AWS identifier for the public subnet AZ"
  type = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for your public subnet"
  type = string
} 

variable "private_subnet_cidr" {
  description = "CIDR block for your private subnet"
  type = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}

variable "domain_name" {
  description = "Domain name for the VPC"
  type = string
}

variable "dns_server_ip" {
  description = "IP address of the DNS server for the VPC"
  type = string
}