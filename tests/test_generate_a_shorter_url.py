import unittest
import os
import json
from handlers import generate_a_shorter_url
import boto3


class TestGenerateId(unittest.TestCase):
    def test_number(self):
        number = 7
        self.assertEqual(len(generate_a_shorter_url.generate_id(number)),
                         number)

    def test_random(self):
        number = 7
        random_number_1 = generate_a_shorter_url.generate_id(number)
        random_number_2 = generate_a_shorter_url.generate_id(number)
        self.assertNotEqual(random_number_1, random_number_2)

    def test_return_type(self):
        number = 7
        random_number_1 = generate_a_shorter_url.generate_id(number)
        self.assertIsInstance(random_number_1, str)


class TestGenerateAShorterUrl(unittest.TestCase):
    def test_normal_status(self):
        event = {'body': json.dumps({"original_url": "https://baidu.com"})}
        context = {}
        os.environ['TABLE_NAME'] = 'urls'
        response_result = generate_a_shorter_url.generate_a_shorter_url(event, context)
        dynamo = boto3.resource('dynamodb').Table(os.environ['TABLE_NAME'])
        response = dynamo.get_item(Key={'Id': json.loads(response_result.get('body', '')).get('Id', '')})

        item = response['Item']
        self.assertEqual(item['original_url'],
                         json.loads(event['body'])['original_url'])


if __name__ == '__main__':
    unittest.main()