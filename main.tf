provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data" {
  bucket = "my-test-data-bucket"
}

resource "aws_s3_bucket_acl" "data_acl" {
  bucket = aws_s3_bucket.data.id
  acl    = "public-read-write"          # KICS: S3 Bucket Allows Public ACL/READ/WRITE
}

resource "aws_s3_bucket_public_access_block" "data_block" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = false        # KICS: S3 Bucket Without Public Access Block
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_security_group" "open_sg" {
  name        = "wide-open-sg"
  description = "allow all"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]          # KICS: Security Group Rule Allows Ingress From Internet to All Ports
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "db" {
  identifier             = "test-db"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "admin"
  password               = "SuperSecret123!"   # KICS: Hardcoded Secret / Password in Plaintext
  publicly_accessible    = true                # KICS: RDS Publicly Accessible
  storage_encrypted      = false               # KICS: RDS Not Encrypted
  skip_final_snapshot    = true
}

resource "aws_iam_policy" "wildcard_policy" {
  name = "wildcard-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"                     # KICS: IAM Policy Allows Actions On All Resources / Full Admin Privileges
      Resource = "*"
    }]
  })
}

resource "aws_ebs_volume" "vol" {
  availability_zone = "us-east-1a"
  size              = 10
  encrypted         = false              # KICS: Unencrypted EBS Volume
}
