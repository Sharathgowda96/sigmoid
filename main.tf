resource "aws_s3_bucket" "onebucket" {
  bucket = "testing-s3-with-terra"
  acl    = "private"
  versioning {
    enabled = true
  }
  tags = {
    Name        = "Bucket1"
    Environment = "Test"
  }
}

resource "aws_iam_policy" "s3_full_access" {
  name = "s3_full_access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::testing-s3-with-terraform",
        "arn:aws:s3:::testing-s3-with-terraform/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "s3_role" {
  name = "S3FullAccessRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "s3_full_access_attachment" {
  name       = "s3_full_access_attachment"
  policy_arn = aws_iam_policy.s3_full_access.arn
  roles      = [aws_iam_role.s3_role.name]
}
