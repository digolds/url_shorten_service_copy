terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

//Create role for Lambda to access AWS Services, such as CloudWatch, DynamoDB etc.
module "role_for_lambda_common" {
  source                = "../role_for_lambda_common"
  state_path_urls_table = "../../dynamodb/prod_urls_table/terraform.tfstate"
  role_name             = "prod_lambda_access_to_aws_services"
  policy_name           = "prod_AccessToLimitedService"
}

output "role_obj" {
  value = module.role_for_lambda_common.role_obj
}
