import boto3
from botocore.exceptions import ClientError
import os


def redirect_from(event, context):
    try:
        dynamo = boto3.resource('dynamodb').Table(os.environ['TABLE_NAME'])
        Id = event.get('pathParameters', {}).get('id', {})
        if not Id:
            return {'error_msg': 'Empty Id'}
        response = dynamo.get_item(Key={'Id': Id})
    except ClientError as e:
        return {'error_msg': e.response['Error']['Message']}
    else:
        item = response['Item']
        real_url = item['original_url']
        return {'statusCode': 301, 'headers': {'Location': real_url}}
