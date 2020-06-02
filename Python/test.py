
# from rediscluster import StrictRedisCluster
# startup_nodes = [
#     {"host":"47.106.75.252", "port":6000},
#     {"host":"47.106.75.252", "port":6001},
#     {"host":"47.106.75.252", "port":6002},
#     {"host":"47.106.75.252", "port":6003},
#     {"host":"47.106.75.252", "port":6004},
#     {"host":"47.106.75.252", "port":6005}
# ]
# rc = StrictRedisCluster(startup_nodes=startup_nodes, decode_responses=True)
# rc.set('key1','value1')
# rc.set('key2','value2')
# rc.set('key3','value3')
# rc.set('key4','value4')
# rc.set('key5','value5')





# from rediscluster import StrictRedisCluster

# list = [
#     '14900000001',
#     '14900000002',
#     '14900000003',
#     '14900000004',
#     '14900000005',
#     '14900000006',
#     '14900000007',
#     '14900000008',
#     '14900000009',
#     '14900000010'
# ]

# #def redis_cluster(list):
# redis_nodes = [
#     {"host":"47.106.75.252", "port":6000},
#     {"host":"47.106.75.252", "port":6001},
#     {"host":"47.106.75.252", "port":6002},
#     {"host":"47.106.75.252", "port":6003},
#     {"host":"47.106.75.252", "port":6004},
#     {"host":"47.106.75.252", "port":6005}
# ]
# redisconn = StrictRedisCluster(startup_nodes=redis_nodes)
# redisconn.set('user_phone_'+list[i],'888888')

    # try:
    #     redisconn = StrictRedisCluster(startup_nodes=redis_nodes)
    # except:
    #     print('error')

    # for i in range(0,len(list)):
        #redisconn.set('user_phone_'+list[i],'888888')
        # print(redisconn.get('user_phone_'+list[i]))

#redis_cluster(list)

import redis
from rediscluster import StrictRedisCluster

r = redis.Redis(host='47.106.75.252',port=6000,password='123456')
redis_nodes = [
    # {"host":"47.106.75.252", "port":6000,"password":'123456'},
    {"host":"47.106.75.252", "port":6001,"password":'123456'},
    {"host":"47.106.75.252", "port":6002,"password":'123456'}
    # {"host":"47.106.75.252", "port":6003,password='123456'},
    # {"host":"47.106.75.252", "port":6004,password='123456'},
    # {"host":"47.106.75.252", "port":6005,password='123456'}
]
redisconn = StrictRedisCluster(startup_nodes=redis_nodes)
redisconn.set('key1','value1')
# r.set('user_phone_14900000001','888888')
print redisconn.get('key1')









