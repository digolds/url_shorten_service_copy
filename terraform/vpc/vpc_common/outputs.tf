output "vpc_instance" {
  value = aws_vpc.main
}

output "lambda_subnets" {
  value = aws_subnet.lambda_subnets
}

output "cache_subnets" {
  value = aws_subnet.cache_subnets
}

output "public_subnets" {
  value = aws_subnet.public_subnets
}

output "lambda_route_tables" {
  value = aws_route_table.lambda_subnets_route_tables
}
