# 1) IAM role & instance profile so EC2 can call Secrets Manager & STS
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions   = [
      "sts:AssumeRole"
      ]
    principals {
      type        = "Service"
      identifiers = [
        "ec2.amazonaws.com"
        ]
    }
  }
}

resource "aws_iam_role" "ec2_s3_ro_role" {
  name               = var.ec2_aws_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

data "aws_iam_policy_document" "bucket_access" {
  statement {
    actions   = [
      "s3:GetObject",
      "s3:ListBucket"
      ]
    resources = var.s3_arn
  }
}

resource "aws_iam_role_policy" "bucket_access_policy" {
  name = "${var.team_name}-ec2-s3-ro-policy"
  role   = aws_iam_role.ec2_s3_ro_role.id
  policy = data.aws_iam_policy_document.bucket_access.json
}

resource "aws_iam_instance_profile" "ec2_s3_ro_instance_profile" {
  name = "${var.team_name}-ec2-s3-ro-profile"
  role = aws_iam_role.ec2_s3_ro_role.name
}