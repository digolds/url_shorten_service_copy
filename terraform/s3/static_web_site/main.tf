terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

resource "aws_s3_bucket" "static_web_site" {
  bucket = "shorten-url-service"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning {
    enabled = true
  }
}

output "s3_obj" {
  value = aws_s3_bucket.static_web_site
}
