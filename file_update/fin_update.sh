#!/bin/bash

cd ~
wget http://47.75.104.65/httpLogicServer-1.0-SNAPSHOT.jar


cp /opt/lexin-java/httpLogicServer-1.0-SNAPSHOT.jar /opt/lexin-java/httpLogicServer-1.0-SNAPSHOT.jar_bak
mv ~/httpLogicServer-1.0-SNAPSHOT.jar /opt/lexin-java/httpLogicServer-1.0-SNAPSHOT.jar
mv httpLogicServer-1.0-SNAPSHOT.jar bk_jar/httpLogicServer-1.0-SNAPSHOT.jar_7.13

sh stop.sh
sh ../manage/stop.sh
ps -ef | grep jar |grep -v grep|awk '{print $2}'
kill 16244 26064
supervisord
supervisorctl status


