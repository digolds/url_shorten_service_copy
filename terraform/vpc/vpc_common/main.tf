terraform {
  required_version = "= 0.12.19"
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route" "route_for_internet" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  lambda_subnet_cidr_blocks = var.newbits_for_lambda == 0 ? {} : {
    for zone_id in data.aws_availability_zones.available.zone_ids :
    zone_id => cidrsubnet(var.cidr_block, var.newbits_for_lambda, index(data.aws_availability_zones.available.zone_ids, zone_id) + 1)
  }
  cache_subnet_cidr_blocks = var.newbits_for_cache == 0 ? {} : {
    for zone_id in data.aws_availability_zones.available.zone_ids :
    zone_id => cidrsubnet(var.cidr_block, var.newbits_for_cache, index(data.aws_availability_zones.available.zone_ids, zone_id) + 1)
  }
  public_subnet_cidr_blocks = var.newbits_for_public_subnet == 0 ? {} : {
    for zone_id in data.aws_availability_zones.available.zone_ids :
    zone_id => cidrsubnet(var.cidr_block, var.newbits_for_public_subnet, index(data.aws_availability_zones.available.zone_ids, zone_id) + 1)
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

resource "aws_route_table" "cache_subnets_route_tables" {
  for_each = var.should_attach_nat_to_cache ? aws_subnet.cache_subnets : {}
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngws[each.key].id
  }
}

resource "aws_route_table_association" "association_for_cache_subnets" {
  for_each       = aws_route_table.cache_subnets_route_tables
  subnet_id      = aws_subnet.cache_subnets[each.key].id
  route_table_id = each.value.id
}

resource "aws_subnet" "lambda_subnets" {
  for_each             = local.lambda_subnet_cidr_blocks
  availability_zone_id = each.key
  vpc_id               = aws_vpc.main.id
  cidr_block           = each.value
  tags = {
    subnet_type = "private"
    Name        = "${var.vpc_name}-zone-${each.key}"
  }
}

resource "aws_route_table" "lambda_subnets_route_tables" {
  for_each = var.should_attach_nat_to_lambda ? aws_subnet.lambda_subnets : {}
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngws[each.key].id
  }
}

resource "aws_route_table_association" "association_for_lambda_subnets" {
  for_each       = aws_route_table.lambda_subnets_route_tables
  subnet_id      = aws_subnet.lambda_subnets[each.key].id
  route_table_id = each.value.id
}

resource "aws_subnet" "public_subnets" {
  for_each             = local.public_subnet_cidr_blocks
  availability_zone_id = each.key
  vpc_id               = aws_vpc.main.id
  cidr_block           = each.value
  tags = {
    subnet_type = "public"
    Name        = "${var.vpc_name}-zone-${each.key}"
  }
}

resource "aws_route_table" "public_subnet_route_tables" {
  for_each = aws_subnet.public_subnets
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "association_for_public_subnet" {
  for_each       = aws_route_table.public_subnet_route_tables
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = each.value.id
}

resource "aws_eip" "eips" {
  for_each = aws_subnet.public_subnets
}

resource "aws_nat_gateway" "ngws" {
  for_each      = aws_subnet.public_subnets
  allocation_id = aws_eip.eips[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "${var.vpc_name}-zone-${each.value.id}"
  }

  depends_on = [aws_eip.eips, aws_internet_gateway.igw]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
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
