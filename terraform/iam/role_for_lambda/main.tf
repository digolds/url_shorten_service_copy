terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

//Create role for Lambda to access AWS Services, such as CloudWatch, DynamoDB etc.
module "iam_roles" {
  source = "../iam_roles"
  role_policies = {
    lambda_access_to_aws_services = {
      type                   = ""
      identifiers            = []
      assume_role_policy     = data.aws_iam_policy_document.trust_policy_for_lambda.json
      iam_policy_name        = "AccessToLimitedService"
      iam_policy_description = "Give aceess to AWS Services, such as CloudWatch, DynamoDB etc."
      iam_policy             = data.aws_iam_policy_document.lambda_access_to_aws_services.json
    }
  }
}

// trust policy
data "aws_iam_policy_document" "trust_policy_for_lambda" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

// policy for accessing AWS services
data "aws_iam_policy_document" "lambda_access_to_aws_services" {
  statement {
    sid = "LambdaAccessToCloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "LambdaAccessToDynamoDB"
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem"
    ]

    resources = [
      data.terraform_remote_state.urls_table_state.outputs.table_obj.arn,
    ]
  }

  statement {
    sid    = "LambdaAccessToElasticMemcache"
    effect = "Allow"

    actions = [
      "elasticache:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "LambdaAccessToEc2"
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]

    resources = [
      "*",
    ]
  }
}

data "terraform_remote_state" "urls_table_state" {
  backend = "local"

  config = {
    path = "../../dynamodb/urls_table/terraform.tfstate"
  }
}

output "role_obj" {
  value = module.iam_roles.roles_map.lambda_access_to_aws_services
}
