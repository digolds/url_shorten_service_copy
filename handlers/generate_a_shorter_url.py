import os
import string
import random
import logging
import json
logger = logging.getLogger()
logger.setLevel(logging.INFO)

import boto3


def generate_a_shorter_url(event, context):
    id = generate_id(7)
    logger.info('## 7 digits random number')
    logger.info(id)
    logger.info('## Event')
    logger.info(event)
    logger.info('## Environment variables')
    logger.info(os.environ)

    original_url = json.loads(event['body'])['original_url']
    dynamo = boto3.resource('dynamodb').Table(os.environ['TABLE_NAME'])
    response = dynamo.put_item(Item={'Id': id, 'original_url': original_url})
    logger.info('## Dynamodb put_item result')
    logger.info(response)
    return id


def generate_id(number):
    res = ''.join(
        random.choices(string.ascii_uppercase + string.digits, k=number))
    return res