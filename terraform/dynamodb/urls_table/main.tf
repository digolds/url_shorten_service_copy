terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

resource "aws_dynamodb_table" "basic_dynamodb_table" {
  name           = "urls"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }
}

output "table_obj" {
  value = aws_dynamodb_table.basic_dynamodb_table
}
