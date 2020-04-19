terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

module "redirect_from_function" {
  source        = "../common"
  function_name = "redirect_from"
  handler_name  = "redirect_from"
}

module "generate_a_shorter_url_function" {
  source        = "../common"
  function_name = "generate_a_shorter_url"
  handler_name  = "generate_a_shorter_url"
}

output "redirect_from_function_obj" {
  value = module.redirect_from_function.function_obj
}

output "generate_a_shorter_url_function_obj" {
  value = module.generate_a_shorter_url_function.function_obj
}
