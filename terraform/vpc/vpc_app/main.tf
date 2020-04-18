terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

module "vpc_app" {
  source                    = "../vpc_common"
  cidr_block                = "10.23.0.0/16"
  vpc_name                  = "vpc_app"
  newbits_for_lambda        = 5
  newbits_for_cache         = 8
  newbits_for_public_subnet = 0
  port_memcache             = 11211
}

output "vpc_instance" {
  value = module.vpc_app.vpc_instance
}

output "lambda_subnets" {
  value = module.vpc_app.lambda_subnets
}

output "cache_subnets" {
  value = module.vpc_app.cache_subnets
}

output "public_subnets" {
  value = module.vpc_app.public_subnets
}

output "security_group_ins" {
  value = module.vpc_app.security_group_ins
}
