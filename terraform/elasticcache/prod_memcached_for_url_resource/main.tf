terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

data "terraform_remote_state" "vpc_prod_state" {
  backend = "local"

  config = {
    path = "../../vpc/vpc_prod/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc_peering_prod_state" {
  backend = "local"

  config = {
    path = "../../vpc/vpc_peering_prod/terraform.tfstate"
  }
}

resource "aws_elasticache_cluster" "cluster_instance" {
  cluster_id           = "prod-url-resource-cluster"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = length(data.terraform_remote_state.vpc_prod_state.outputs.cache_subnets)
  parameter_group_name = "default.memcached1.5"
  port                 = tolist(data.terraform_remote_state.vpc_peering_prod_state.outputs.sg_for_cache.ingress)[0].from_port
  security_group_ids   = [data.terraform_remote_state.vpc_peering_prod_state.outputs.sg_for_cache.id, ]
  subnet_group_name    = aws_elasticache_subnet_group.default.name
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "prod-memcache-cache-subnet"
  subnet_ids = [for k, v in data.terraform_remote_state.vpc_prod_state.outputs.cache_subnets : v.id]
}

output "memcached_obj" {
  value = aws_elasticache_cluster.cluster_instance
}
