# url_shorten_service

## make use of terraform to provision AWS services

* role_for_lambda depend on urls_table
* memcached_for_url_resource depend on vpc_app
* lambda_functions depend on urls_table, role_for_lambda, vpc_app
* urls_api depend on lambda_functions

urls_table, role_for_lambda, (vpc_app, vpc_codebuild, vpc_peering), memcached_for_url_resource, lambda_functions, urls_api