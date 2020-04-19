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
    path = "../vpc_prod/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc_codebuild_state" {
  backend = "local"

  config = {
    path = "../vpc_codebuild/terraform.tfstate"
  }
}

resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = data.terraform_remote_state.vpc_prod_state.outputs.vpc_instance.id
  vpc_id      = data.terraform_remote_state.vpc_codebuild_state.outputs.vpc_instance.id
  auto_accept = true
}

resource "aws_route" "route_to_vpc_prod" {
  route_table_id            = data.terraform_remote_state.vpc_codebuild_state.outputs.vpc_instance.main_route_table_id
  destination_cidr_block    = data.terraform_remote_state.vpc_prod_state.outputs.vpc_instance.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "route_to_vpc_codebuild" {
  route_table_id            = data.terraform_remote_state.vpc_prod_state.outputs.vpc_instance.main_route_table_id
  destination_cidr_block    = data.terraform_remote_state.vpc_codebuild_state.outputs.vpc_instance.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# route codebuild traffic to memcache in vpc_app
resource "aws_route" "codebuild_subnets_to_memcache_subnets" {
  for_each                  = data.terraform_remote_state.vpc_codebuild_state.outputs.lambda_route_tables
  route_table_id            = each.value.id
  destination_cidr_block    = data.terraform_remote_state.vpc_prod_state.outputs.vpc_instance.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "memcache_subnets_to_codebuild_subnets" {
  for_each                  = data.terraform_remote_state.vpc_prod_state.outputs.cache_route_tables
  route_table_id            = each.value.id
  destination_cidr_block    = data.terraform_remote_state.vpc_codebuild_state.outputs.vpc_instance.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

locals {
  vpc_name          = data.terraform_remote_state.vpc_codebuild_state.outputs.vpc_instance.tags.Name
  vpc_app_name      = data.terraform_remote_state.vpc_prod_state.outputs.vpc_instance.tags.Name
  port_for_memcache = 11211
}

# vpc_app security
resource "aws_security_group" "sg_for_cache" {
  name        = "${local.vpc_app_name}-attach-to-cache"
  description = "Allow input traffic to memcache"
  vpc_id      = data.terraform_remote_state.vpc_prod_state.outputs.vpc_instance.id

  ingress {
    description = "traffic from VPC"
    from_port   = local.port_for_memcache
    to_port     = local.port_for_memcache
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc_prod_state.outputs.vpc_instance.cidr_block,
      data.terraform_remote_state.vpc_codebuild_state.outputs.vpc_instance.cidr_block
    ]
  }

  tags = {
    Name = "${local.vpc_app_name}-attach-to-cache"
  }

  depends_on = [aws_vpc_peering_connection.vpc_peering, ]
}


resource "aws_security_group" "sg_for_lambda" {
  name        = "${local.vpc_app_name}-attach-to-lambda"
  description = "Allow lambda function access to memcache"
  vpc_id      = data.terraform_remote_state.vpc_prod_state.outputs.vpc_instance.id

  egress {
    description     = "Allow access to memcache"
    from_port       = local.port_for_memcache
    to_port         = local.port_for_memcache
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_for_cache.id, ]
  }

  egress {
    description = "Allow access to internet, in order to access S3 or DynamoDB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.vpc_app_name}-attach-to-lambda"
  }
}

resource "aws_security_group" "sg_for_vpc_app" {
  name        = "prod-${local.vpc_name}-attach-to-codebuild"
  description = "Allow CodeBuild access to internet and memcache in peer vpc_app"
  vpc_id      = data.terraform_remote_state.vpc_codebuild_state.outputs.vpc_instance.id

  egress {
    description     = "Allow CodeBuild access to memcache"
    from_port       = local.port_for_memcache
    to_port         = local.port_for_memcache
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_for_cache.id, ]
  }

  egress {
    description = "Allow CodeBuild access to internet, in order to access S3 or DynamoDB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-${local.vpc_name}-attach-to-codebuild"
  }

  depends_on = [aws_vpc_peering_connection.vpc_peering, ]
}

output "sg_for_vpc_app" {
  value = aws_security_group.sg_for_vpc_app
}

output "sg_for_cache" {
  value = aws_security_group.sg_for_cache
}

output "sg_for_lambda" {
  value = aws_security_group.sg_for_lambda
}
