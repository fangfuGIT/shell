#!/bin/bash
#Author: fangfu
#date: 2018-11-10


prompt()
{
	while true
	do
		echo -e -n "$1 [yes/no/exit]? "
		if [ "$CONFIRM_YES" == "1" ]; then
			echo "yes"
			echo ""
			return 0
		fi
		read PROMPT_ANSWER
		if [ -z "$PROMPT_ANSWER" ]; then
			continue
		else
			if [ "$PROMPT_ANSWER" == "yes" ]; then
				echo ""
				return 0
			elif [ "$PROMPT_ANSWER" == "no" ]; then
				echo ""
				return 1
			elif [ "$PROMPT_ANSWER" == "exit" ]; then
				echo ""
				exit 0
			else
				continue
			fi
		fi
	done
}


function menu()
	{
	echo "----------------------------------"
	echo "please enter your choise:"
	echo "(1) Backup Databases"
	echo "(2) Restore Databases"
	#echo "(3) Restore Databases before Drop old Databases"
	echo "(4) Exit"
	echo "----------------------------------"
	read input
	case $input in
		1)
		BackupDB;;
		2)
		RestoreDB_menu;;
		#3)
		#RestoreDB_beforeDrop;;
		4)
		exit;;
	esac
	}

	
function RestoreDB_menu()
	{
	echo "----------------------------------"
	echo "please enter your choise again:"
	echo "(1) Restore db_center_game Databases"
	echo "(2) Restore db Databases"
	echo "(3) Restore mart Databases"
	echo "(4) Restore log Databases"
	echo "(5) Exit"
	echo "----------------------------------"
	read input
	case $input in
		1)
		Restore_center;;
		2)
		Restore_db;;
		3)
		Restore_mart;;
		4)
		Restore_log;;
		5)
		exit;;
	esac
	}
	
	
	
function BackupDB()
	{
		if [ ! -d "/data/2018backup/center" ]; then
 		    mkdir -p /data/2018backup/center/
		fi
		if [ ! -d "/data/2018backup/db" ]; then
 		    mkdir -p /data/2018backup/db/
		fi
		if [ ! -d "/data/2018backup/mart" ]; then
 		    mkdir -p /data/2018backup/mart/
		fi
		if [ ! -d "/data/2018backup/log" ]; then
 		    mkdir -p /data/2018backup/log/
		fi		
		echo "===================="
		echo "======About to start backing up this databases:"
		cat center_list.txt
		prompt "========== Are you sure Backup db_center_game Databases ?"
		read -t 30 -s -p "请输入Mysql密码:" passwd
		for line in `cat center_list.txt`		
		do
		 echo $line
		 mysqldump --default-character-set=utf8 -uroot -p$passwd --no-autocommit --set-gtid-purged=OFF --skip-lock-tables --single-transaction --master-data=2 -q -e -E $line -R  > /data/2018backup/center/$line.sql
		done
		echo "center backup is done!"
		echo "============"
		echo "======About to start backing up this databases:"
		cat db_list.txt
		prompt "========== Are you sure Backup db Databases ?"
		for line in `cat db_list.txt`		
		do
		 echo $line
		 mysqldump --default-character-set=utf8 -uroot -p$passwd --no-autocommit --set-gtid-purged=OFF --skip-lock-tables --single-transaction --master-data=2 -q -e -E $line -R  > /data/2018backup/db/$line.sql
		done
		echo "db backup is done!"
		echo "============"
		echo "======About to start backing up this databases:"
		cat mart_list.txt
		prompt "========== Are you sure Backup mart Databases ?"
		for line in `cat mart_list.txt`		
		do
		 echo $line
		 mysqldump --default-character-set=utf8 -uroot -p$passwd --no-autocommit --set-gtid-purged=OFF --skip-lock-tables --single-transaction --master-data=2 -q -e -E $line -R  > /data/2018backup/mart/$line.sql
		done
		echo "mart backup is done!"
		echo "============"
		echo "======About to start backing up this databases:"
		cat log_list.txt
		prompt "========== Are you sure Backup log Databases ?"
		for line in `cat log_list.txt`		
		do
		 echo $line
		 mysqldump --default-character-set=utf8 -uroot -p$passwd --no-autocommit --set-gtid-purged=OFF --skip-lock-tables --single-transaction --master-data=2 -q -e -E $line -R  > /data/2018backup/log/$line.sql
		done
		echo "log backup is done!"		
	}

	
function Restore_center()
	{
		if [ ! -f "center_list.txt" ];then
		    echo "=====> center_list.txt is not exist ! please check it!"
			exit
		fi
		if [ ! -d "/data/2018backup" ]; then
 		    mkdir -p /data/2018backup
		fi
		read -t 30 -p "请输入原db服务器的外网IP地址:" ServerIP
		scp -r -P 16333 root@$ServerIP:/data/2018backup/center /data/2018backup
		echo ""
	    cat cat center_list.txt
		prompt "========== Are you sure Restore center_list Database ?"
		read -t 30 -s -p "请输入Mysql密码:" password
		for line in `cat center_list.txt`
		do
			echo $line
			echo -e "create database $line character set utf8;"| mysql -uroot -p$password
			mysql -uroot -p$password -D $line < /data/2018backup/center/$line.sql
		done		
	}	
	
	
function Restore_db()
	{
		if [ ! -f "db_list.txt" ];then
		    echo "=====> db_list.txt is not exist ! please check it!"
			exit
		fi	
		if [ ! -d "/data/2018backup" ]; then
 		    mkdir -p /data/2018backup
		fi
		read -t 30 -p "请输入原db服务器的外网IP地址:" ServerIP
		scp -r -P 16333 root@$ServerIP:/data/2018backup/db /data/2018backup
		echo ""
	    cat cat db_list.txt
		prompt "========== Are you sure Restore db_list Database ?"
		read -t 30 -s -p "请输入Mysql密码:" password
		for line in `cat db_list.txt`
		do
			echo $line
			echo -e "create database $line character set utf8;"| mysql -uroot -p$password
			mysql -uroot -p$password -D $line < /data/2018backup/db/$line.sql
		done		
	}	
	

function Restore_mart()
	{
		if [ ! -f "mart_list.txt" ];then
		    echo "=====> mart_list.txt is not exist ! please check it!"
			exit
		fi	
		if [ ! -d "/data/2018backup" ]; then
 		    mkdir -p /data/2018backup
		fi
		read -t 30 -p "请输入原db服务器的外网IP地址:" ServerIP
		scp -r -P 16333 root@$ServerIP:/data/2018backup/mart /data/2018backup
		echo ""
	    cat cat mart_list.txt
		prompt "========== Are you sure Restore mart_list Database ?"
		read -t 30 -s -p "请输入Mysql密码:" password
		for line in `cat mart_list.txt`
		do
			echo $line
			echo -e "create database $line character set utf8;"| mysql -uroot -p$password
			mysql -uroot -p$password -D $line < /data/2018backup/mart/$line.sql
		done		
	}	
	

function Restore_log()
	{
		if [ ! -f "log_list.txt" ];then
		    echo "=====> log_list.txt is not exist ! please check it!"
			exit
		fi	
		if [ ! -d "/data/2018backup" ]; then
 		    mkdir -p /data/2018backup
		fi
		read -t 30 -p "请输入原db服务器的外网IP地址:" ServerIP
		scp -r -P 16333 root@$ServerIP:/data/2018backup/log /data/2018backup
		echo ""
	    cat cat log_list.txt
		prompt "========== Are you sure Restore log_list Database ?"
		read -t 30 -s -p "请输入Mysql密码:" password
		for line in `cat log_list.txt`
		do
			echo $line
			echo -e "create database $line character set utf8;"| mysql -uroot -p$password
			mysql -uroot -p$password -D $line < /data/2018backup/log/$line.sql
		done		
	}	
		
		
function RestoreDB_beforeDrop()
	{
		read -t 30 -p "请输入原db服务器的外网IP地址:" ServerIP
		scp -r -P 16333 root@$ServerIP:/data/2018backup /data/
		echo ""
	    cat list.txt
		prompt "========== Are you sure Restore Database ?"
		read -t 30 -s -p "请输入Mysql密码:" password
		for line in `cat list.txt`
		do
			echo $line
			echo -e "drop database $line;"| mysql -uroot -p$password
			echo -e "create database $line character set utf8;"| mysql -uroot -p$password
			mysql -uroot -p$password -D $line < /data/2018backup/$line.sql
		done
	}
	

function main()
	{  

		menu
	}


main $* 

