terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

//Create a bucket for hosting web
module "web_bucket" {
  source                = "../public_web_basic"
  bucket_name = "static_web_for_stage"
}

output "web_host_s3" {
  value = module.web_bucket.s3_obj
}