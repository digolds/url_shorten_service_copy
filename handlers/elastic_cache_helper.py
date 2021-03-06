import time
import uuid
import sys
import socket
import elasticache_auto_discovery
from pymemcache.client.hash import HashClient
import config

memcache_client = None


def get_elastic_cache_client():
    global memcache_client
    if memcache_client:
        return memcache_client

    elasticache_config_endpoint = config.config["elastic_cache_url"] + ":11211"
    nodes = elasticache_auto_discovery.discover(elasticache_config_endpoint)
    nodes = map(lambda x: (x[1], int(x[2])), nodes)
    memcache_client = HashClient(nodes)
    return memcache_client