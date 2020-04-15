terraform {
  required_version = "= 0.12.19"
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  lambda_subnet_cidr_blocks = {
    for zone_id in data.aws_availability_zones.available.zone_ids :
    zone_id => cidrsubnet(var.cidr_block, var.newbits_for_lambda, index(data.aws_availability_zones.available.zone_ids, zone_id) + 1)
  }
  cache_subnet_cidr_blocks = {
    for zone_id in data.aws_availability_zones.available.zone_ids :
    zone_id => cidrsubnet(var.cidr_block, var.newbits_for_cache, index(data.aws_availability_zones.available.zone_ids, zone_id) + 1)
  }
}

resource "aws_subnet" "cache_subnets" {
  for_each             = local.cache_subnet_cidr_blocks
  availability_zone_id = each.key
  vpc_id               = aws_vpc.main.id
  cidr_block           = each.value
  tags = {
    subnet_type = "private"
  }
}

resource "aws_subnet" "lambda_subnets" {
  for_each             = local.lambda_subnet_cidr_blocks
  availability_zone_id = each.key
  vpc_id               = aws_vpc.main.id
  cidr_block           = each.value
  tags = {
    subnet_type = "private"
  }
}

resource "aws_security_group" "allow_lambda" {
  name        = "allow_lambda"
  description = "Allow lambda function access to memcache"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "traffic from VPC"
    from_port   = var.port_memcache
    to_port     = var.port_memcache
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block, ]
  }

  tags = {
    Name = "allow_lambda"
  }
}
