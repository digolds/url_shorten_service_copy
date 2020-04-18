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

output "security_group_ins" {
  value = aws_security_group.allow_lambda
}
