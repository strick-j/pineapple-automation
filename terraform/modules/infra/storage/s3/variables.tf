variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
} 

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "versioning" {
  description = "Enable versioning for the S3 bucket."
  type        = bool
  default     = false
}

variable "asset_owner_name" {
  description = "The name of the asset owner."
  type        = string
}

variable "allowed_ips" {
  description = "Additional IPs/CIDRs allowed to access the bucket"
  type        = list(string)
  default     = []
}

variable "s3_vpc_endpoint_id" {
  description = "ID of the S3 VPC endpoint to allow in the bucket policy"
  type        = string
}