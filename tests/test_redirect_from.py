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
        response = dynamo.put_item(Item={
            'Id': Id,
            'original_url': original_url
        })
        event = {'pathParameters': {"id": Id}}
        context = {}

        response = redirect_from.redirect_from(event, context)
        self.assertEqual(response['statusCode'], 301)
        self.assertEqual(response['headers']['Location'], original_url)

    def test_invalid_credential_status(self):
        os.environ['TABLE_NAME'] = 'urls'
        os.environ['AWS_ACCESS_KEY_ID'] = 'AKIAIOSFODNN7EXAMPLE'
        os.environ[
            'AWS_SECRET_ACCESS_KEY'] = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
        response = redirect_from.redirect_from({}, {})
        self.assertTrue('error_msg' in response)
        del os.environ['AWS_ACCESS_KEY_ID']
        del os.environ['AWS_SECRET_ACCESS_KEY']


if __name__ == '__main__':
    unittest.main()