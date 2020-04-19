terraform {
  required_version = "= 0.12.19"
}

resource "aws_dynamodb_table" "basic_dynamodb_table" {
  name           = var.env
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }
}
