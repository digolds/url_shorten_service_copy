import boto3
import os

def redirect_from(event, context):
    dynamo = boto3.resource('dynamodb').Table(os.environ['TABLE_NAME'])
    response = dynamo.get_item(
        Key={
                'Id': event["pathParameters"]["id"]
            })
    item = response['Item']
    real_url = item['original_url']
    return {
        "statusCode" : 301,
        "headers" : {
            "Location" : real_url
        }
    }