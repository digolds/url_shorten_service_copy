terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

resource "aws_elasticache_cluster" "cluster_instance" {
  cluster_id           = "url-resource-cluster"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 2
  parameter_group_name = aws_elasticache_parameter_group.default.name
  port                 = 11211
  security_group_ids = ["sg-08d6cbcee43c875f2",]
  subnet_group_name = aws_elasticache_subnet_group.default.name
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "cache-params-mem15"
  family = "memcached1.5"

  description = "Parameter for memcached 1.5"
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "memcache-cache-subnet"
  subnet_ids = ["subnet-0fa5d39fcc8159c5c", "subnet-04cf8c15eb365a82b", "subnet-09c2a29a343dd1b86"]
}

output "memcached_obj" {
  value = aws_elasticache_cluster.cluster_instance
}
