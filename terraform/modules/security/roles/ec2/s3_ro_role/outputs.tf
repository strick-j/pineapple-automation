output "profile_name" {
  value     = aws_iam_instance_profile.ec2_s3_ro_instance_profile.name
}

output "profile_arn" {
  value     = aws_iam_instance_profile.ec2_s3_ro_instance_profile.arn
}