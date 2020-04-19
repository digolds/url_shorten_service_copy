terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

module "redirect_from_function" {
  source                     = "../common"
  function_name              = "prod_redirect_from"
  handler_name               = "redirect_from"
  path_vpc_app_state         = "../../vpc/vpc_prod/terraform.tfstate"
  path_vpc_peering_state     = "../../vpc/vpc_peering_prod/terraform.tfstate"
  path_role_for_lambda_state = "../../iam/prod_role_for_lambda/terraform.tfstate"
  path_urls_table_state      = "../../dynamodb/prod_urls_table/terraform.tfstate"
}

module "generate_a_shorter_url_function" {
  source                     = "../common"
  function_name              = "prod_generate_a_shorter_url"
  handler_name               = "generate_a_shorter_url"
  path_vpc_app_state         = "../../vpc/vpc_prod/terraform.tfstate"
  path_vpc_peering_state     = "../../vpc/vpc_peering_prod/terraform.tfstate"
  path_role_for_lambda_state = "../../iam/prod_role_for_lambda/terraform.tfstate"
  path_urls_table_state      = "../../dynamodb/prod_urls_table/terraform.tfstate"
}

output "redirect_from_function_obj" {
  value = module.redirect_from_function.function_obj
}

output "generate_a_shorter_url_function_obj" {
  value = module.generate_a_shorter_url_function.function_obj
}
