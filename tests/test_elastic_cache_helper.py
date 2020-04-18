import unittest
from handlers import elastic_cache_helper


class TestMemcacheClient(unittest.TestCase):
    def test_client_creation_status(self):
        client = elastic_cache_helper.get_elastic_cache_client()
        self.assertTrue(client is not None)

    def test_client_get_status(self):
        client = elastic_cache_helper.get_elastic_cache_client()
        test_key = 'key'
        test_value = 'test value'
        client.set(test_key, test_value)
        v = client.get(test_key).decode('utf-8')
        self.assertTrue(v == test_value)


if __name__ == '__main__':
    unittest.main()