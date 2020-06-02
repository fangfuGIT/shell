#!/bin/bash

mongo --port 28018 --eval "use test;db.user.update({\"abc\":123},{$set:{\"loc\":{\"lng\":4,\"lat\":3}}});exit;"
#mongo --port 28018 <<EOF
#show dbs
#use test
#db.user.update({"abc": 123},{$set:{"loc":{"lng":4,"lat":3}}})
#exit

#EOF
