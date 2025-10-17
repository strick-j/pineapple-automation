variable "ec2_aws_role_name" {
  description = "Name of the EC2 IAM Role"
  type        = string
}

variable "s3_arn" {
  description = "The ARN of the s3 bucket"
  type        = list(string)
}

variable "team_name" {
  description = "Team name for resource naming"
  type        = string
}