#! /bin/bash


dbname="lexin_server"
port=28018
mongoexport="/opt/mongodb/bin/mongoexport"
mongo="/opt/mongodb/bin/mongo"
mongoimport="/opt/mongodb/bin/mongoimport"
dumpfile="/data/mongo_mt_2020.dat"
nowdate=`date +%s`
ntime=`expr $nowdate \* 1000`
days="200"
oneday="86400000"
ctime=`expr $days \* $oneday`
qdate=`expr $ntime - $ctime`
#echo $qdate
colname="user_moment"
newcolname="user_moment_new"
rm -rf $dumpfile
echo `date` >> mongo_mt.log
echo "begin..." >> mongo_mt.log
$mongoexport -h 127.0.0.1:$port -d $dbname -c $colname -q '{createdTime:{$lte:NumberLong('$qdate')}}' -o $dumpfile >> mongo_mt.log
if [ ! -f "$dumpfile" ]; then
  echo "mongoexport dump file have some wrongs" >> mongo_mt.log
  exit 0
fi
$mongoimport -h 127.0.0.1:$port -d $dbname -c $newcolname $dumpfile >> mongo_mt.log
sql="DBQuery.shellBatchSize=9999999999999;db.$colname.remove({"createdTime" :{\$lt:NumberLong(\"$qdate\")}});"
echo $sql|$mongo --port $port $dbname >> mongo_mt.log
echo "" >> mongo_mt.log

