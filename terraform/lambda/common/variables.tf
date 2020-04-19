variable "function_name" {
  type = string
}

variable "path_vpc_app_state" {
  type    = string
  default = "../../vpc/vpc_app/terraform.tfstate"
}

variable "path_vpc_peering_state" {
  type    = string
  default = "../../vpc/vpc_peering/terraform.tfstate"
}

variable "path_role_for_lambda_state" {
  type    = string
  default = "../../iam/role_for_lambda/terraform.tfstate"
}

variable "path_urls_table_state" {
  type    = string
  default = "../../dynamodb/urls_table/terraform.tfstate"
}

variable "handler_name" {
  type = string
}
