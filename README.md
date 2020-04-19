# url_shorten_service

## make use of terraform to provision AWS services

* role_for_lambda depend on urls_table
* memcached_for_url_resource depend on vpc_app
* lambda_functions depend on urls_table, role_for_lambda, vpc_app
* urls_api depend on lambda_functions

follow the order below to provision infrustructure:

* urls_table
* role_for_lambda
* (vpc_app, vpc_codebuild, vpc_peering)
* memcached_for_url_resource
* lambda_functions
* urls_api

After successfully provisioning, create CodeBuild manually and update policy using by it with the following statements:

```bash
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:us-east-2:<YOUR AWS ACCOUNT ID>:log-group:/aws/codebuild/url-shorten-service-on-master",
                "arn:aws:logs:us-east-2:<YOUR AWS ACCOUNT ID>:log-group:/aws/codebuild/url-shorten-service-on-master:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::codepipeline-us-east-2-*",
                "arn:aws:s3:::shorten-url-service*",
                "arn:aws:s3:::swagger-ui-for-url-shorten-service*",
                "arn:aws:lambda:us-east-2:<YOUR AWS ACCOUNT ID>:function:redirect_from",
                "arn:aws:lambda:us-east-2:<YOUR AWS ACCOUNT ID>:function:generate_a_shorter_url",
                "arn:aws:dynamodb:us-east-2:<YOUR AWS ACCOUNT ID>:table/urls",
                "arn:aws:apigateway:*::/*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation",
                "lambda:UpdateFunctionCode",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "apigateway:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases"
            ],
            "Resource": [
                "arn:aws:codebuild:us-east-2:<YOUR AWS ACCOUNT ID>:report-group/url-shorten-service-on-master-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ec2:CreateNetworkInterfacePermission",
            "Resource": "arn:aws:ec2:us-east-2:<YOUR AWS ACCOUNT ID>:network-interface/*",
            "Condition": {
                "StringEquals": {
                    "ec2:Subnet": [
                        "arn:aws:ec2:us-east-2:<YOUR AWS ACCOUNT ID>:subnet/subnet-044be5588b021dac3",
                        "arn:aws:ec2:us-east-2:<YOUR AWS ACCOUNT ID>:subnet/subnet-00ca4a3475de82107",
                        "arn:aws:ec2:us-east-2:<YOUR AWS ACCOUNT ID>:subnet/subnet-0db4ad08d56811d85"
                    ],
                    "ec2:AuthorizedService": "codebuild.amazonaws.com"
                }
            }
        }
    ]
}
```