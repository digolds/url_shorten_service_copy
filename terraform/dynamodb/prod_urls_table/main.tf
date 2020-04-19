terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

module "urls_table" {
  source = "../urls_table_common"
  env    = "prod_urls"
}

output "table_obj" {
  value = module.urls_table.table_obj
}
