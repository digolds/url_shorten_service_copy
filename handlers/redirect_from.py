import boto3
from botocore.exceptions import ClientError
import os

import elastic_cache_helper


def _generate_redirect_response(real_url):
    return {'statusCode': 301, 'headers': {'Location': real_url}}


def redirect_from(event, context):
    try:
        # 1. parse id from request
        Id = event.get('pathParameters', {}).get('id', {})
        if not Id:
            return {'error_msg': 'Empty Id'}
        # 2. opt for getting url from elastic memcache
        url_from_cache = elastic_cache_helper.get_elastic_cache_client().get(
            Id)
        if url_from_cache:
            return _generate_redirect_response(url_from_cache.decode('utf-8'))

        # 3. back to dynamodb to get url
        dynamo = boto3.resource('dynamodb').Table(os.environ['TABLE_NAME'])
        response = dynamo.get_item(Key={'Id': Id})
    except ClientError as e:
        return {'error_msg': e.response['Error']['Message']}
    else:
        item = response['Item']
        real_url = item['original_url']
        # 4. put the retrieved url to elastic memcache
        elastic_cache_helper.get_elastic_cache_client().set(Id, real_url)
        return _generate_redirect_response(real_url)