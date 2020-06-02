#!/bin/bash


function body () {
   local account="I5566016"
   local password="ANzmGyix1ofe79"
   local msg=$(echo "$@" | cut -d" " -f1-)
   local mobile="639674506855,639674000000"
 #  local mobile=$1
   local senderId=""
   echo """{
    \"account\" : \"$account\",
    \"password\" : \"$password\",
    \"msg\" : \"$msg\",
    \"mobile\" : \"$mobile\",
    \"senderId\" : \"$senderId\"
}"""
}

echo $(body $1 $2 $3)
url="http://intapi.253.com/send"
curl -H "Content-Type:application/json" -X POST --data "$(body $1 $2 $3)" $url
