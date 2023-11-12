# define aws region replace it with your region

variable "region" {
  default = "ap-southeast-2"
}

variable "bucketName" {
  default = "sweetserenity.net"
  type    = string
}

# aws provider block

provider "aws" {
  region = var.region
}

# S3 static website bucket

resource "aws_s3_bucket" "my-static-website" {
  bucket = "sweetserenity.net" # give a unique bucket name
  tags = {
    Name = "aws-s3-bucket-tag"
  }
}

resource "aws_s3_bucket_website_configuration" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_object" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id
  key    = "index.html"
  source = "static-page/index.html"
  content_type = "text/html"
}


# S3 bucket ACL access

resource "aws_s3_bucket_ownership_controls" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "example-policy" {
  bucket = aws_s3_bucket.my-static-website.id
  policy = templatefile("s3-policy.json", { bucket = var.bucketName })
  depends_on = [aws_s3_bucket_public_access_block.my-static-website]
}



# s3 static website url

output "website_url" {
  value = "http://${aws_s3_bucket.my-static-website.bucket}.s3-website.${var.region}.amazonaws.com"
}
