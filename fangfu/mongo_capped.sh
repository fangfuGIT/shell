#! /bin/bash

#get collection names

dbname="lexin_server"
port=28018
mongoexport="/opt/mongodb-3.4.0/bin/mongoexport"
mongo="/opt/mongodb-3.4.0/bin/mongo"
mongoimport="/opt/mongodb-3.4.0/bin/mongoimport"
dumpfile="/data/mongo_dump.dat"
rows=10

allcol=`$mongo --port $port $dbname --eval "db.getCollectionNames()"` 
col=`echo ${allcol#*[}`
col=`echo ${col%]*}`
colname=`echo $col|sed 's/\"//g'|sed 's/\,//g'|awk '{print $6}'`
col_str="group_chat_msgs"
for i in $col
	do
	    colname=`echo $i|sed 's/\"//g'|sed 's/\,//g'`
            result=$(echo $colname|grep "${col_str}")
	    if [[ $result != "" ]];then
		line=`$mongo --port $port $dbname --eval "db.$colname.count()"|awk '{print $NF}'`
	        count=`echo $line|awk '{print $NF}'`
		num=$((count-${rows}))
   		if [[ $count -gt $rows ]];then
			$mongoexport -h 127.0.0.1:$port -d $dbname -c $colname -o $dumpfile --skip $num
		else
			$mongoexport -h 127.0.0.1:$port -d $dbname -c $colname -o $dumpfile
		fi
		$mongo --port $port $dbname --eval "db.$colname.drop()"
		$mongo --port $port $dbname --eval "db.createCollection(\"$colname\",{capped:true, autoIndexId:true, size:2097152, max:$rows})"
		$mongo --port $port $dbname --eval "db.$colname.createIndex({\"time\":1})"
		$mongoimport -h 127.0.0.1:$port -d $dbname -c $colname $dumpfile
		
	    fi
	done


