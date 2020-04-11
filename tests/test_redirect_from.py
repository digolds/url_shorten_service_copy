import unittest
import os
from handlers import redirect_from, generate_a_shorter_url
import boto3

class TestRedirectFrom(unittest.TestCase):
    
    def test_normal_status(self):
        os.environ['TABLE_NAME'] = 'urls'
        dynamo = boto3.resource('dynamodb').Table(os.environ['TABLE_NAME'])
        Id = generate_a_shorter_url.generate_id(7)
        original_url = "https://bibi.com"
        response = dynamo.put_item(
        Item={
            'Id': Id,
            'original_url': original_url
        }
    )
        event = {
            'pathParameters' : {
                "id" : Id
            }
        }
        context = {}
        response = redirect_from.redirect_from(event, context)
        self.assertEqual(response['statusCode'], 301)
        self.assertEqual(response['headers']['Location'], original_url)

if __name__ == '__main__':
    unittest.main()