terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

locals {
  vpc_name = "vpc_for_code_build"
}


module "vpc_codebuild" {
  source                    = "../vpc_common"
  cidr_block                = "10.105.0.0/16"
  vpc_name                  = local.vpc_name
  newbits_for_lambda        = 8
  newbits_for_cache         = 0
  newbits_for_public_subnet = 12
}

output "vpc_instance" {
  value = module.vpc_codebuild.vpc_instance
}

output "lambda_subnets" {
  value = module.vpc_codebuild.lambda_subnets
}

output "cache_subnets" {
  value = module.vpc_codebuild.cache_subnets
}

output "public_subnets" {
  value = module.vpc_codebuild.public_subnets
}

output "lambda_route_tables" {
  value = module.vpc_codebuild.lambda_route_tables
}

output "cache_route_tables" {
  value = module.vpc_codebuild.cache_route_tables
}
