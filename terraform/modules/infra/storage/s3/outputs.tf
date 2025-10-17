output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.secure_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.secure_bucket.arn
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.secure_bucket.bucket
}