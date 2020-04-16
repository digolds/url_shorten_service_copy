import os

os.sys.path.insert(0, os.getcwd() + '/handlers/')
os.sys.path.insert(1, os.getcwd() + '/handlers/package')
os.sys.path.insert(2, os.getcwd() + '/handlers/package/pymemcache')

import package.elasticache_auto_discovery
import package.pymemcache.client.hash