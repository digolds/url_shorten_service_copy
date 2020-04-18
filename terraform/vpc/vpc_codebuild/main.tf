terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

module "vpc_app" {
  source                      = "../vpc_common"
  cidr_block                  = "10.105.0.0/16"
  vpc_name                    = "vpc_for_code_build"
  newbits_for_lambda          = 0
  newbits_for_cache           = 8
  newbits_for_public_subnet   = 12
  port_memcache               = 11211
  should_attach_nat_to_cache  = true
  should_attach_nat_to_lambda = true
}

data "terraform_remote_state" "vpc_app_state" {
  backend = "local"

  config = {
    path = "../vpc_app/terraform.tfstate"
  }
}


resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = data.terraform_remote_state.vpc_app_state.outputs.vpc_instance.id
  vpc_id      = module.vpc_app.vpc_instance.id
  auto_accept = true
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
