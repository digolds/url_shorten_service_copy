terraform {
  required_version = "= 0.12.19"
}

resource "aws_lambda_function" "lambda_function_instance" {
  filename         = "../init_version.zip"
  function_name    = var.function_name
  role             = data.terraform_remote_state.role_for_lambda_state.outputs.role_obj.arn
  handler          = "${var.function_name}.${var.function_name}"
  source_code_hash = filebase64sha256("../init_version.zip")
  runtime          = "python3.6"
  vpc_config {
    subnet_ids         = [for k, v in data.terraform_remote_state.vpc_app_state.outputs.lambda_subnets : v.id]
    security_group_ids = [data.terraform_remote_state.vpc_app_state.outputs.security_group_ins.id, ]
  }

  environment {
    variables = {
      TABLE_NAME = data.terraform_remote_state.urls_table_state.outputs.table_obj.name
    }
  }
}

data "terraform_remote_state" "vpc_app_state" {
  backend = "local"

  config = {
    path = "../../vpc/vpc_app/terraform.tfstate"
  }
}

data "terraform_remote_state" "role_for_lambda_state" {
  backend = "local"

  config = {
    path = "../../iam/role_for_lambda/terraform.tfstate"
  }
}

data "terraform_remote_state" "urls_table_state" {
  backend = "local"

  config = {
    path = "../../dynamodb/urls_table/terraform.tfstate"
  }
}
