#!/bin/bash
#



#!/bin/sh
# database backup scripts
# create by pengwan yunwei Jerry
# create time 2014.11.19
#


	function strDecoding() {
		#解密mysql用户名和密码
		encryptCode="$1"
		theCode=`echo ${encryptCode} | sed 's/l%d+f/D/g;s/&ldf(&/F/g;s/L^!D=F/M/g;s/@=lidefeng/c/g;s/&=lidefeng@love@ymy/==/g;s/L%D+F/d/g;s/53cYa;/b/g;s/6d:a/v/g;s/fengl%d/w/g' | base64 -d -i`
		theLen=${#theCode};
		i=0
		strHead=''
		strTail=''
		while [ "${i}" -lt "${theLen}" ]; do
				theStr="${theCode:$i:1}"
				isOdd=`expr ${i} % 2`
				if [ "${isOdd}" -eq 1 ]; then
						strHead="${theStr}${strHead}"
				else
						strTail="${strTail}${theStr}"
				fi
				i=`expr $i + 1`
		done
		echo "${strTail}${strHead}"
	}
	
	#sock判断，配置参数
	function init() {
	     sid=`basename $0`
        export pid="${pid}-->$sid"
        theFiledir=`echo $(cd "$(dirname "$0")"; pwd)`
        cd ${theFiledir}
		USER=`strDecoding "@=lidefengnR6d:a53cYa;fengl%d&=lidefeng@love@ymy"`
		PASSWORD=`strDecoding "@=lidefengl%d+f&ldf(&3L^!D=FmL^!D=Fj@=lidefengS56"`
		CUR_DATE=$(date +%Y%m%d) #当前日期
		CUR_HOUR=$(date +%H)     #当前小时
		CUR_TIME=$(date +%H%M%S) #当前时间
		MYSQLDUMP_PATH="/usr/local/mysql/bin" #mysql路径
	}
	
	function dbbackup() {
		BACKUP_DIR=$1
		SOCK=$2
		echo " " >> $LOGFILE
		echo " " >> $LOGFILE
		echo "-------------------------------------------" >> $LOGFILE
		echo $(date +"%y-%m-%d %H:%M:%S") >> $LOGFILE
		echo "---------------------------------" >> $LOGFILE
		echo "Mysql Backup Is Starting" >> $LOGFILE #开始备份
		cd $BACKUP_DIR
		
		for i in $DUMP_DATABASE #找到需要备份的数据库
		do
			echo "$i is dump starting." >>$LOGFILE
			
			if [ ! -z $SOCK ];then
				
				$MYSQLDUMP_PATH/mysql -u${USER} -p${PASSWORD} -S $SOCK -Be "show slave status \G" > $SLAVE_PATH #收集备份时的slave状态
				MYSQLDUMP=$($MYSQLDUMP_PATH/mysqldump -u${USER} -p${PASSWORD} --default-character-set=utf8 -S $SOCK --skip-opt --single-transaction --set-gtid-purged=OFF --no-autocommit -e -q -E -R  $i > $DUMPFILE_PATH) #备份命令
				
			else
	
	            $MYSQLDUMP_PATH/mysql -u${USER} -p${PASSWORD}  -Be "show slave status \G" > $SLAVE_PATH #收集备份时的slave状态		
				MYSQLDUMP=$($MYSQLDUMP_PATH/mysqldump -u${USER} -p${PASSWORD}  --default-character-set=utf8 --skip-opt --single-transaction --set-gtid-purged=OFF --no-autocommit -q -e -E -R  $i > $DUMPFILE_PATH) #备份命令
				
			fi
			$MYSQLDUMP >> $LOGFILE 2>&1
			if [[ $? == 0 ]]; then
			tar zvcf $DBBAK_NAME $DUMPFILE_NAME >> $LOGFILE 2>&1 #压缩备份文件
			fi
			echo "$i is dump seccess." >>$LOGFILE
			sleep 3 #3秒后继续
			rm -f $DUMPFILE_NAME #删除源文件
		done
		echo "----------------------------------" >> $LOGFILE
		echo "Mysql Backup Is finish" >> $LOGFILE #备份成功
		echo "-------------------------------------------" >> $LOGFILE
		
	}
	
	function del_backup() {
		 DEL_BACKUP_DIR=$1
		`find $DEL_BACKUP_DIR -type f -ctime +10 -exec rm -f {} \;` >> $LOGFILE 2>&1 #删除30天之前的文件
		`find $DEL_BACKUP_DIR -name 'log_*' -type f -ctime +2 -exec rm -f {} \;` >> $LOGFILE 2>&1 #删除15天之前的日志备份文件
		`find $DEL_BACKUP_DIR -name 'drop_*' -type f -ctime +1 -exec rm -f {} \;` >> $LOGFILE 2>&1 #删除15天之前的日志备份文件
		#`find $SLAVE_DIR -type f -ctime +10 -exec rm -f {} \;` >> $LOGFILE 2>&1 #删除10天之前的文件
		`find $DEL_BACKUP_DIR -empty -ctime +2 -type d | xargs -i rmdir {};` 
		if [ $?  == 0 ];then #如果硬盘占用大于80%，继续删除
			for ((Y=10;Y>=5;Y--))
			do
				DF_OUT=($(df /data -k  | sed -e "1d" -e "s/%//" ))
				if [ ${DF_OUT[4]} -gt 80 ];then
					`find $DEL_BACKUP_DIR -ctime +$Y -exec rm -f {} \;` >> $LOGFILE 2>&1
				else
					break
				fi
			done
		fi
	}

	function backup_one() {
		init
		BACKUP_DIR="/data/dbbak/$CUR_DATE/$CUR_HOUR"
		SLAVE_DIR="/data/dbbak/dbbackup/$CUR_DATE/$CUR_HOUR"
		LOGFILE="/data/crontab/dbbak.log"
		
		#检查日志文件夹是否创建
		[ -d /data/crontab ] || mkdir -p /data/crontab
		#创建备份目录
		if [ ! -d $BACKUP_DIR ];then
			mkdir -p "$BACKUP_DIR"
		fi
		#创建slave_status目录
		[ -d $SLAVE_DIR ] || mkdir -p $SLAVE_DIR
		ALLDATABASE=$($MYSQLDUMP_PATH/mysql -u${USER} -p${PASSWORD} -NBe "show databases"  | grep -E '^db_cqz|^log_cqz|^db_center|^mysql' | egrep -v "^del|.*_bak*") #查看关于sctx的所有的数据库
		DUMP_DATABASE=""
		for a in $ALLDATABASE  
		do
				CUR_DATE=$(date +%Y%m%d) #当前日期
				CUR_HOUR=$(date +%H)     #当前小时
				CUR_TIME=$(date +%H%M%S) #当前时间
				DUMP_DATABASE=$a
				DUMPFILE_NAME="${DUMP_DATABASE}_${CUR_DATE}_${CUR_TIME}.sql" #备份文件名
				DUMPFILE_PATH="$BACKUP_DIR/$DUMPFILE_NAME" #备份文件全路径
				DBBAK_NAME=${DUMPFILE_NAME}.tar.gz #压缩备份文件名
				DBBAK_PATH="$BACKUP_DIR/$DBBAK_NAME" #压缩的备份文件全路径
				SLAVE_NAME="$slave_status_${DUMP_DATABASE}_${CUR_DATE}_${CUR_TIME}.txt" #slave
				SLAVE_PATH="$SLAVE_DIR/$SLAVE_NAME" #slave信息位置
				dbbackup $BACKUP_DIR
				del_backup '/data/dbbak'
		done
	}
	
	function backup_more() {
		init
		for X in `seq 0 $SOCKCOUNT`
		do
			SOCK=${FINDSOCK[$X]}
			TYPE=`echo $SOCK | awk -F '_' '{print $2}' | awk -F '/' '{print $1}'`
			if [ -d /data1 ];then
				BACKUP_DIR="/data1/dbbak_$TYPE"
				LOGFILE="/data1/crontab/dbbak.log"
				#检查日志文件夹是否创建
				[ -d /data1/crontab ] || mkdir -p /data1/crontab
			else 
				BACKUP_DIR="/data/dbbak_$TYPE"
				LOGFILE="/data/crontab/dbbak.log"
				#检查日志文件夹是否创建
				[ -d /data/crontab ] || mkdir -p /data/crontab
			fi
			#创建备份目录
			if [ ! -d $BACKUP_DIR ];then
				mkdir -p "$BACKUP_DIR"
			fi
			ALLDATABASE=$($MYSQLDUMP_PATH/mysql -u${USER} -p${PASSWORD} -S $SOCK -NBe "show databases"  | grep -E 'db_cqz|log_cqz|db_center|mysql' | egrep -v "^del|.*_bak*") #查看关于cqz的所有的数据库
			DUMP_DATABASE=""
			for a in $ALLDATABASE  
			do
				DUMP_DATABASE=$a
				DUMPFILE_NAME="${DUMP_DATABASE}_${CUR_DATE}_${CUR_TIME}.sql" #备份文件名
				DUMPFILE_PATH="$BACKUP_DIR/$DUMPFILE_NAME" #备份文件全路径
				DBBAK_NAME=${DUMPFILE_NAME}.tar.gz #压缩备份文件名
				DBBAK_PATH="$BACKUP_DIR/$DBBAK_NAME" #压缩的备份文件全路径
				dbbackup $BACKUP_DIR $SOCK
				del_backup '/data/dbbak'
			done
		done
	}

	function main() {
		#FINDSOCK=(`find /data -type s -name *.sock`)
		#SOCKNUM=${#FINDSOCK[*]}
		#let SOCKCOUNT=$SOCKNUM-1
		#if [ $SOCKNUM -gt 1 ];then
			#backup_more
		#else
			backup_one
		#fi
	}

	main





































DUMP=/usr/local/mongodb/bin/mongodump
OUT_DIR=/data/mongodb_bak/mongodb_bak_now
TAR_DIR=/data/mongodb_bak/mongodb_bak_list
DATE=`date +%Y_%m_%d`
DB_USER=myadmin
DB_PASS=******
DAYS=20  
TAR_BAK="mongodb_bak_$DATE.tar.gz"
cd $OUT_DIR
rm -rf $OUT_DIR/*
mkdir -p $OUT_DIR/$DATE
$DUMP -h 127.0.0.1:27017 -u $DB_USER -p $DB_PASS --authenticationDatabase "admin" -o $OUT_DIR/$DATE   #备份全部数据库
tar -zcvf $TAR_DIR/$TAR_BAK $OUT_DIR/$DATE
find $TAR_DIR/ -mtime +$DAYS -delete
exit





