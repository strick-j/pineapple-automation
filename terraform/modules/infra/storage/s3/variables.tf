variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
} 

var "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "versioning" {
  description = "Enable versioning for the S3 bucket."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}