import json
import request
import random
import math
from pymongo import MongoClient

def generate_random_gps(base_log=None, base_lat=None, radius=None):
    radius_in_degrees = radius / 111300
    u = float(random.uniform(0.0, 1.0))
    v = float(random.uniform(0.0, 1.0))
    w = radius_in_degrees * math.sqrt(u)
    t = 2 * math.pi * v
    x = w * math.cos(t)
    y = w * math.sin(t)
    longitude = y + base_log
    latitude = x + base_lat
    loga = '%.6f' % longitude
    lata = '%.6f' % latitude
    return loga, lata

client=MongoClient("localhost",28018)
db=client.tmp2
#db.authenticate('root','123456')
ID=2121
#db.user.update_one({'_id':'2122','status':1},{'$set':{'loc':{'lng':log1,'lat':lat1}}})
ID=str(ID)
for i in range(0,697892):
#for i in range(0,5):
    log1, lat1 = generate_random_gps(base_log=120.7, base_lat=30, radius=1000000)
    log2=float(log1)
    lat2=float(lat1)
    db.user.update_one({'_id':'{}'.format(ID),'status':1},{'$set':{'loc':{'lng':log2,'lat':lat2}}})
    ID=int(ID)
    ID=ID+1

#for i in range(1,5):
#    ID=ID+1
#    db.user.update_one({"abc":ID},{'$set':{'loc':{'lng':log1,'lat':lat1}}})



#for i in range(1,5): 
#log1, lat1 = generate_random_gps(base_log=120.7, base_lat=30, radius=1000000)
#    ID=ID+1
#        print(doc)
#db.user.insert({"a": 2},{$set: {"loc":{"lng": log1,"lat": lat1}}})
#db.user.insert({"a": 33})


#col=db.test
#for item in col.find():
#   print(item)
#client.close()

#print(log1)
#print(lat1)
