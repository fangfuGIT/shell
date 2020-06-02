import redis
from rediscluster import StrictRedisCluster
redis_nodes = [
    {"host":"47.106.75.252", "port":6000},
    {"host":"47.106.75.252", "port":6001},
    {"host":"47.106.75.252", "port":6002},
    {"host":"47.106.75.252", "port":6003},
    {"host":"47.106.75.252", "port":6004},
    {"host":"47.106.75.252", "port":6005}
]
redisconn = StrictRedisCluster(startup_nodes=redis_nodes,password='123456')
redisconn.set('key1','value1')
redisconn.set('key2','value2')
print(redisconn.get('key1'))
