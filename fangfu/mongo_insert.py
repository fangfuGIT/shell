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
db.pointSync.insert({"receiverId":"1","messageId":"5825e7ecacf9459888e2dd5be4167e19-1573539179037","time":"1573539179036","source":"android","type":"2","userId":"0","contentType":"1","content":"weqsfhwiu rwrb cnwqbyecinwuebcweubcwebtcbiwcwquwebcqwy qbweyciuwbeciuwqbcabgnwcbnwetbdcgnweweiugfiyusegyfwopegrhouegfewfweuwirecniebrywnieugfehufuheuisgfeiyugfyuwgicnr8 cywefgnciugfy 63487t23rgcnwg 9ywgacer cwiur cbiwbfneybi72t7tcqnwbgcbigny8oyrcnigr89bncyr wncisa wegcbw97enw8wcinwwiurncbq8wbyw8r3286c87 wrcntwgqe7cixt34687r8ewcgqwe7cy8wbdnwuyd87wcysrnwe7rywb8cnqr8ef wcr7w rcibbefcrifuwbeyncriywesbxniqwyecinexaylnciaxwicanawisewaawiurncbwe7brcynwbityarbcnw7siabfnwcnriywnesicybwnsicynicxyalnwdmcniwesfncsxeinocniunsdioxsfsuzknciucnesiaycbnsisfybncsniewsnfcusficfnsufkhesinfchks nisxhnciuehsi focnwieciescnsicnoasowcswoesiweynrcisecseifcfnxewascwsfnscigf cngis efucnisnfbywecbe68rtbw387rctw3478cnortw9rowcnxwynxr7cq90ncbq cnwe9ry7cn3rcybw9nryc839rcnbw9nterwc87nwoabn3wcbwe87rtcx3wrt7eenw8cnrwc9w87nbetwrc87wercaewqrcnwyne7wbcrnewscre fyneoscgsrfe coinseso necoesly7easrcbs78eftefy8w7groaeygfewo7f8ewoewwerynwevyr9sy8rewvjeoncy8ewy7rng8ersnyfcaweyorefcd8esnvoe8salvcesfovcefs"})
#db.authenticate('root','123456')
#ID=2121
#db.user.update_one({'_id':'2122','status':1},{'$set':{'loc':{'lng':log1,'lat':lat1}}})
#ID=str(ID)
#for i in range(0,697892):
#    log1, lat1 = generate_random_gps(base_log=120.7, base_lat=30, radius=1000000)
#    log2=float(log1)
#    lat2=float(lat1)
#    db.user.update_one({'_id':'{}'.format(ID),'status':1},{'$set':{'loc':{'lng':log2,'lat':lat2}}})
#    ID=int(ID)
#    ID=ID+1



#pointSync

#"receiverId":"1","messageId":"5825e7ecacf9459888e2dd5be4167e19-1573539179037","time":"1573539179036","source":"android","type":"2","userId":"0","contentType":"1","content":"weqsfhwiu rwrb cnwqbyecinwuebcweubcwebtcbiwcwquwebcqwy qbweyciuwbeciuwqbcabgnwcbnwetbdcgnweweiugfiyusegyfwopegrhouegfewfweuwirecniebrywnieugfehufuheuisgfeiyugfyuwgicnr8 cywefgnciugfy 63487t23rgcnwg 9ywgacer cwiur cbiwbfneybi72t7tcqnwbgcbigny8oyrcnigr89bncyr wncisa wegcbw97enw8wcinwwiurncbq8wbyw8r3286c87 wrcntwgqe7cixt34687r8ewcgqwe7cy8wbdnwuyd87wcysrnwe7rywb8cnqr8ef wcr7w rcibbefcrifuwbeyncriywesbxniqwyecinexaylnciaxwicanawisewaawiurncbwe7brcynwbityarbcnw7siabfnwcnriywnesicybwnsicynicxyalnwdmcniwesfncsxeinocniunsdioxsfsuzknciucnesiaycbnsisfybncsniewsnfcusficfnsufkhesinfchks nisxhnciuehsi focnwieciescnsicnoasowcswoesiweynrcisecseifcfnxewascwsfnscigf cngis efucnisnfbywecbe68rtbw387rctw3478cnortw9rowcnxwynxr7cq90ncbq cnwe9ry7cn3rcybw9nryc839rcnbw9nterwc87nwoabn3wcbwe87rtcx3wrt7eenw8cnrwc9w87nbetwrc87wercaewqrcnwyne7wbcrnewscre fyneoscgsrfe coinseso necoesly7easrcbs78eftefy8w7groaeygfewo7f8ewoewwerynwevyr9sy8rewvjeoncy8ewy7rng8ersnyfcaweyorefcd8esnvoe8salvcesfovcefs


