#! /bin/bash



 # scp root@172.31.157.232:/opt/netty/imchat-deliver/imchat-deliver-1.0-SNAPSHOT.jar .
 # 			# 47.52.255.159的内网IP是 172.31.157.232


#scp root@47.52.255.159:~/auto_start.sh .


sourceip="47.52.255.159"
remotefile="/root/autasdfo_start.sh"
user=root
localpath="/data/www/resources"


 # if ssh ${user}@${remoteip} test -e ${remotefile}; then
 # 	echo yes, the file is exist
 #    #scp ${user}@${remoteip}:${remotefile} ${localpath}

 # else 
 # 	echo the file is not exist,please check it.
 # 	exit 1
 # fi
echo dddd

# if [ 0 -ne $user ];then
RES=`echo $?`
#if [ 0 -ne $user ];then
if [ $? -ne 0 ];then
    echo 000
else 
	echo 111
fi






安装并配置zabbix监控报警，对线上服务器的状态进行监控，并实现微信报警

完成一键安装线上所有软件的自动安装脚本的编写，包括系统优化的功能，能根据需求选择软件安装，已通过测试并投入实用

配置mongodb副本集，实现数据复制，自动切换主从和容灾

搭建https站点，重新申请并配置证书

编写程序自启脚本并加入服务

sql查询，sql语句优化，数据库状态







