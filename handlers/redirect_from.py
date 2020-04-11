import boto3
import os

def redirect_from(event, context):
    return { 
        'message' : "Hello from redirect_from"
    }  
    dynamo = boto3.resource('dynamodb').Table(os.environ['TABLE_NAME'])
    real_url = dynamo.get_item(**event["pathParameters"]["id"])
    return {
        "statusCode" : 301,
        "headers" : {
            "Location" : real_url
        }
    }