#! /bin/bash

nowdate=`date +%Y%m%d_%H%M`
#/opt/mongodb-3.4.0/bin/mongodump  -h 127.0.0.1:28018 -d tmp1 -c user_moment -o /data/mongo_tmp1_0905_3/
#sleep 1
size1=`du mongo_tmp1_0905_3/tmp1|awk '{print $1}'`
#sleep 1
size2=`du mongo_tmp1_0905_3/tmp1|awk '{print $1}'`
size1=456
size2=123
echo "$size1"
echo $size2
if [[ $size1 = $size2 ]];then
	echo "====="
#	tar czvf mongo_tmp1_0905_$nowdate.tar.gz -C mongo_tmp1_0905_3 tmp1
else
echo "aaa"
while [ "$size1" -ne "$size2" ]
do
	echo "bbb"
	sleep 1
        size1=`du mongo_tmp1_0905_3/tmp1|awk '{print $1}'`
        sleep 1
        size2=`du mongo_tmp1_0905_3/tmp1|awk '{print $1}'`
        if [[ $size2 -eq $size2 ]];then
                tar czvf mongo_tmp1_0905_3.tar.gz -C mongo_tmp1_0905_3 tmp1_$nowdate
                break
        fi
done
fi
