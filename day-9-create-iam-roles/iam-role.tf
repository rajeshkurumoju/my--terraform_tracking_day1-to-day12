#create IAM Role
resource "aws_iam_role" "sai" {
  name               = "raj"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# create aws IAM policy
resource "aws_iam_policy" "sai" { 
  name        = "raj"
  description = "s3 and ec2"
  policy      = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:*", "ec2:*"],  # or specify specific actions like ["s3:*", "ec2:*"]
        Resource = "*",    # or specify specific resources like "arn:aws:s3:::example_bucket/*"
      },
    ],
  })
}
#attach policy for IAM Role
resource "aws_iam_role_policy_attachment" "sai" {
    role = aws_iam_role.sai.name
    policy_arn = aws_iam_policy.sai.arn
  
}
