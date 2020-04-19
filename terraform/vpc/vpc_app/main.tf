terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

locals {
  vpc_name          = "vpc_app"
  port_for_memcache = 11211
  cidr_block        = "10.23.0.0/16"
}


module "vpc_app" {
  source                    = "../vpc_common"
  cidr_block                = local.cidr_block
  vpc_name                  = local.vpc_name
  newbits_for_lambda        = 5
  newbits_for_cache         = 8
  newbits_for_public_subnet = 12
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

output "lambda_route_tables" {
  value = module.vpc_app.lambda_route_tables
}

output "cache_route_tables" {
  value = module.vpc_app.cache_route_tables
}

output "port_for_memcache" {
  value = local.port_for_memcache
}
