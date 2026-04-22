# Creaates an IAM role for EC2 instances with permissions for SSM and S3 access.
resource "aws_iam_role" "ec2_role" {
  name = "three-tier-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# This policy attachment allows EC2 instances to communicate with AWS Systems Manager (SSM), enabling features like Session Manager for secure shell access without needing SSH keys, and Run Command for executing commands on instances remotely.
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# This policy allows EC2 instances to read from S3 buckets, which can be useful for fetching configuration files, application code, or other resources stored in S3.
resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Creates an instance profile that can be attached to EC2 instances, allowing them to assume the IAM role and gain the associated permissions.
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "three-tier-ec2-profile"
  role = aws_iam_role.ec2_role.name
}