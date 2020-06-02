#! /bin/bash

#get collection names

dbname="lexin_server"
port=28018
mongoexport="/opt/mongodb/bin/mongoexport"
mongo="/opt/mongodb/bin/mongo"
mongoimport="/opt/mongodb/bin/mongoimport"
dumpfile="/data/mongo_dump.dat"
username="lexin"
password="d7c31b92bc73"
rows=1000
col_str="group_chat_msgs"

allcol=`$mongo --port $port -u $username -p $password --authenticationDatabase "admin" $dbname --eval "db.getCollectionNames()"` 
col=`echo ${allcol#*[}`
col=`echo ${col%]*}`

for i in $col
        do
            colname=`echo $i|sed 's/\"//g'|sed 's/\,//g'`
            result=$(echo $colname|grep "${col_str}")
            if [[ $result != "" ]];then
                line=`$mongo --port $port -u $username -p $password --authenticationDatabase "admin" $dbname --eval "db.$colname.count()"|awk '{print $NF}'`
                count=`echo $line|awk '{print $NF}'`
                num=$((count-${rows}))
                if [[ $count -gt $rows ]];then
                        $mongoexport -h 127.0.0.1:$port -u $username -p $password --authenticationDatabase "admin" -d $dbname -c $colname -o $dumpfile --skip $num
                else
                        $mongoexport -h 127.0.0.1:$port -u $username -p $password --authenticationDatabase "admin" -d $dbname -c $colname -o $dumpfile
                fi
                $mongo --port $port -u $username -p $password --authenticationDatabase "admin" $dbname --eval "db.$colname.drop()"
                $mongo --port $port -u $username -p $password --authenticationDatabase "admin" $dbname --eval "db.createCollection(\"$colname\",{capped:true, autoIndexId:true, size:2097152, max:$rows})"
                $mongo --port $port -u $username -p $password --authenticationDatabase "admin" $dbname --eval "db.$colname.createIndex({\"time\":1})"
                $mongoimport -h 127.0.0.1:$port -u $username -p $password --authenticationDatabase "admin" -d $dbname -c $colname $dumpfile

            fi
        done