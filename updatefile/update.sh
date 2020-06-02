#!/bin/bash
# date:20190725
# auth: ff



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

function sourcemenu()
        {
        echo "-------------------------------"
        echo "please choose the Source Server："
        echo "(1) 47.106.161.199"
        echo "(2) 47.56.84.109"
        echo "(3) exit"
        echo "-------------------------------"
        read input
        case $input in
                1)
                sourcea;;
                2)
                sourceb;;
                3)
                exit;;
                *)
                sourcemenu;;
        esac
        }



function menu()
	{
	echo "----------------------------------"
	echo "please choose the option which need to update："
	echo "(1) deliver"
	echo "(2) eureka"
	echo "(3) handler"
	echo "(4) lexin-java"
	echo "(5) manage"
	echo "(6) job"
	echo "(7) weblogic"
	echo "(8) upload"
	echo "(9) applet"
	echo "(10) offline"
	echo "(0) exit"
	echo "----------------------------------"
	read input
	case $input in
		1)
		deliver;;
		2)
		eureka;;
		3)
		handler;;
		4)
		lexinjavamenu;;
		5)
		managemenu;;
		6)
		jobmenu;;
		7)
		weblogic;;
		8)
		upload;;
		9)
		appletmenu;;
		10)
		offline;;
		0)
		exit;;
		*)
		menu;;
	esac
	}

function jobmenu()
	{
	echo "-------------------------------"
	echo "please choose the job need to update："
	echo "(1) admin"
	echo "(2) executor"
	echo "(3) admin + executor"
	echo "(0) exit"
	echo "-------------------------------"
	read input
	case $input in
		1)
		jobadmin;;
		2)
		jobexecutor;;
		3)
		jobadmin
		jobexecutor;;
		0)
		exit;;
		*)
		jobmenu;;
	esac
	}

function appletmenu()
	{
	echo "-------------------------------"
	echo "please choose the applet need to update："
	echo "(1) applet web"
	echo "(2) applet server"
	echo "(3) web + server"
	echo "(0) exit"
	echo "-------------------------------"
	read input
	case $input in
		1)
		appletweb;;
		2)
		appletserver;;
		3)
		appletweb
		appletserver;;
		0)
		exit;;
		*)
		jobmenu;;
	esac
	}

function lexinjavamenu()
        {
        echo "-------------------------------"
        echo "please choose the server which need to update："
        echo "(1) only update 10.148.0.83"
        echo "(2) only update 10.148.0.84"
        echo "(3) open all nginx configuation (83+ 84)"
        echo "(0) exit"
        echo "-------------------------------"
        read input
        case $input in
                1)
                server83;;
                2)
                server84;;
                3)
                serverall;;
                0)
                exit;;
                *)
                lexinjavamenu;;
        esac
        }

function managemenu()
        {
        echo "-------------------------------"
        echo "please choose the option which you need to operation："
        echo "(1) update manage to 47.106.161.199"
        echo "(2) update manage to lx-web1 and lx-web2"
        echo "(0) exit"
        echo "-------------------------------"
        read input
        case $input in
                1)
                manage199;;
                2)
                manage;;
                0)
                exit;;
                *)
                managemenu;;
        esac
        }

function sourcea()
	{
        source_ip="47.106.161.199"
	sed -i '/\[source_ali\]/a 47.106.161.199' /etc/ansible/hosts	
	}

function sourceb()
        {
        source_ip="47.56.84.109"
	sed -i '/\[source_ali\]/a 47.56.84.109' /etc/ansible/hosts
	}

function manage199()
        {
        path="/opt/netty/manage_update/"
        file="manage.zip"
        source_ip="47.106.161.199"
        sed -i '/\[source_ali\]/a 47.106.161.199' /etc/ansible/hosts
        prompt "========== Are you sure update mange to 199?"
        if [ $? -eq 0 ];then
            echo "" >> ansible.log
            echo "------starting update $nowdata------" >> ansible.log
            ansible-playbook manage199.yml --extra-vars "path=${path} file=${file}"|tee -a ansible.log
        else
            menu
        fi
        }

function manage()
        {
        serverhost="manage"
        serverPath="/opt/manage_bak/"
        path="/opt/netty/manage_update/"
        file="manage.zip"
        prompt "========== Are you sure update manage?"
            if [ $? -eq 0 ];then
                sourcemenu
                AnsiblePull
                su - apple -c "ansible-playbook ${theShelldir}/manage_deploy.yml --extra-vars \"serverhost=${serverhost} serverPath=${serverPath} nowdata=${nowdata} file=${file}\""|tee -a ansible.log
            else
                menu
            fi
        }

function server83()
        {
                                
                serverhost_tcps="tcps"
                serverhost_eureka="eureka"
                serverPath="/etc/nginx/conf.d/"
                fileA="api2.guanglei.mobi.conf"
                fileB="api.hheng.top.conf"
                fileC="api2.hheng.top.conf"
                fileD="lxapi.yiiduii.mobi.conf"
                cp -rf ${theShelldir}/nginxfiles/83.api2.guanglei.mobi.conf  ${theShelldir}/api2.guanglei.mobi.conf
                cp -rf ${theShelldir}/nginxfiles/83.api.hheng.top.conf  ${theShelldir}/api.hheng.top.conf
                cp -rf ${theShelldir}/nginxfiles/83.api2.hheng.top.conf ${theShelldir}/api2.hheng.top.conf
                cp -rf ${theShelldir}/nginxfiles/83.lxapi.yiiduii.mobi.conf  ${theShelldir}/lxapi.yiiduii.mobi.conf
                echo "========== will close nginx about 10.148.0.83"
                prompt "========== Are you sure change all nginx configuration and reload nginx ?"
                if [ $? -eq 0 ];then
                    su - apple -c "ansible-playbook ${theShelldir}/nginx_deploy.yml --extra-vars \"serverhost=${serverhost_tcps} serverPath=${serverPath} fileA=${fileA} fileB=${fileB}\""|tee -a ansible.log
                    su - apple -c "ansible-playbook ${theShelldir}/nginx_deploy.yml --extra-vars \"serverhost=${serverhost_eureka} serverPath=${serverPath} fileA=${fileC} fileB=${fileD}\""|tee -a ansible.log
                else
                    menu
                fi
                rm -rf ${theShelldir}/*.conf
				cp -rf ${theShelldir}/nginxfiles/83hosts /etc/ansible/hosts
                lexinjava
				lexinjavamenu
				
        }

function server84()
        {

	            serverhost_tcps="tcps"
	            serverhost_eureka="eureka"
	            serverPath="/etc/nginx/conf.d/"
	            fileA="api2.guanglei.mobi.conf"
	            fileB="api.hheng.top.conf"
	            fileC="api2.hheng.top.conf"
	            fileD="lxapi.yiiduii.mobi.conf"
	            cp -rf ${theShelldir}/nginxfiles/84.api2.guanglei.mobi.conf  ${theShelldir}/api2.guanglei.mobi.conf
	            cp -rf ${theShelldir}/nginxfiles/84.api.hheng.top.conf  ${theShelldir}/api.hheng.top.conf
	            cp -rf ${theShelldir}/nginxfiles/84.api2.hheng.top.conf ${theShelldir}/api2.hheng.top.conf
	            cp -rf ${theShelldir}/nginxfiles/84.lxapi.yiiduii.mobi.conf  ${theShelldir}/lxapi.yiiduii.mobi.conf
	            echo "========== will close nginx about 10.148.0.84"
	            prompt "========== Are you sure change all nginx configuration and reload nginx ?"
	            if [ $? -eq 0 ];then
	                su - apple -c "ansible-playbook ${theShelldir}/nginx_deploy.yml --extra-vars \"serverhost=${serverhost_tcps} serverPath=${serverPath} fileA=${fileA} fileB=${fileB}\""|tee -a ansible.log
	                su - apple -c "ansible-playbook ${theShelldir}/nginx_deploy.yml --extra-vars \"serverhost=${serverhost_eureka} serverPath=${serverPath} fileA=${fileC} fileB=${fileD}\""|tee -a ansible.log
	            else
	                menu
	            fi
	            rm -rf ${theShelldir}/*.conf
				cp -rf ${theShelldir}/nginxfiles/84hosts /etc/ansible/hosts
				lexinjava84
				lexinjavamenu
        }


function serverall()
        {

                serverhost_tcps="tcps"
                serverhost_eureka="eureka"
                serverPath="/etc/nginx/conf.d/"
                fileA="api2.guanglei.mobi.conf"
                fileB="api.hheng.top.conf"
                fileC="api2.hheng.top.conf"
                fileD="lxapi.yiiduii.mobi.conf"
                cp -rf ${theShelldir}/nginxfiles/api2.guanglei.mobi.conf  ${theShelldir}/api2.guanglei.mobi.conf
                cp -rf ${theShelldir}/nginxfiles/api.hheng.top.conf  ${theShelldir}/api.hheng.top.conf
                cp -rf ${theShelldir}/nginxfiles/api2.hheng.top.conf ${theShelldir}/api2.hheng.top.conf
                cp -rf ${theShelldir}/nginxfiles/lxapi.yiiduii.mobi.conf  ${theShelldir}/lxapi.yiiduii.mobi.conf
                prompt "========== Are you sure open all nginx entrance and reload nginx ?"
                if [ $? -eq 0 ];then
                    su - apple -c "ansible-playbook ${theShelldir}/nginx_deploy.yml --extra-vars \"serverhost=${serverhost_tcps} serverPath=${serverPath} fileA=${fileA} fileB=${fileB}\""|tee -a ansible.log
                    su - apple -c "ansible-playbook ${theShelldir}/nginx_deploy.yml --extra-vars \"serverhost=${serverhost_eureka} serverPath=${serverPath} fileA=${fileC} fileB=${fileD}\""|tee -a ansible.log
                else
                    menu
                fi
                rm -rf ${theShelldir}/*.conf
        }


function deliver()
	{
				serverhost="deliver"
				serverPath="/opt/imchat-deliver/"
				path="/opt/netty/imchat-deliver/"
				file="imchat-deliver-1.0-SNAPSHOT.jar"
				prompt "========== Are you sure update deliver?"
				if [ $? -eq 0 ];then
				    sourcemenu
				    AnsiblePull
				    AnsiblePush
				else
				    menu
				fi
	}

function eureka()
	{
				serverhost="eureka"
				serverPath="/opt/imchat-eureka/"
				path="/opt/netty/imchat-eureka/"
				file="eurekaServer-1.0-SNAPSHOT.jar"
				prompt "========== Are you sure update eureka?"
				if [ $? -eq 0 ];then
					sourcemenu
					AnsiblePull
					AnsiblePush
				else
				    menu
				fi
	}

function handler()
	{
				serverhost="handler"
				serverPath="/opt/imchat-logicHandler/"
				path="/opt/netty/imchat-logicHandler/"
				file="imchat-logicHandler-1.0-SNAPSHOT.jar"
				prompt "========== Are you sure update handler?"
				if [ $? -eq 0 ];then
					sourcemenu
					AnsiblePull
					AnsiblePush
				else
				    menu
				fi
	}

function lexinjava()
	{
				serverhost="lexinjava"
				serverPath="/opt/lexin-java/"
				path="/opt/lexin-java/"
				file="httpLogicServer-1.0-SNAPSHOT.jar"
                prompt "========== Are you sure update lexinjava?"
                if [ $? -eq 0 ];then
                        sourcemenu
                        AnsiblePull
                        AnsiblePush
                else
                    menu
                fi
	}

function lexinjava84()
	{
				serverhost="lexinjava"
				serverPath="/opt/lexin-java/"
				path="/opt/lexin-java/"
				file="httpLogicServer-1.0-SNAPSHOT.jar"
                prompt "========== Are you sure update lexinjava?"
                if [ $? -eq 0 ];then
                        sourcemenu
                        AnsiblePush
                else
                    menu
                fi
	}

function msgRetry()
	{
				serverhost="msg"
				serverPath="/opt/msgRetry/"
				path="/opt/netty/msgRetry/"
				file="msgRetry-1.0-SNAPSHOT.jar"
				prompt "========== Are you sure update msgRetry?"
				if [ $? -eq 0 ];then
					AnsiblePull
				else
				    menu
				fi
	}


function jobadmin()
	{
				serverhost="job"
				serverPath="/opt/job/admin/"
				path="/opt/job/admin/"
				file="jobAdminServer-1.0-SNAPSHOT.jar"
				prompt "========== Are you sure update job/admin?"
				if [ $? -eq 0 ];then
					sourcemenu
					AnsiblePull
					AnsiblePush
				else
				    menu
				fi
	}

function jobexecutor()
	{
				serverhost="job"
				serverPath="/opt/job/executor/"
				path="/opt/netty/job/executor/"
				file="jobExecutor-1.0-SNAPSHOT.jar"
				prompt "========== Are you sure update job/executor?"
				if [ $? -eq 0 ];then
					sourcemenu
					AnsiblePull
					AnsiblePush
				else
				    menu
				fi
	}

function weblogic()
	{
				serverhost="weblogic"
				serverPath="/opt/webLogicServer/"
				path="/opt/netty/web/"
				file="webLogicServer-1.0-SNAPSHOT.jar"
				prompt "========== Are you sure update weblogic?"
				if [ $? -eq 0 ];then
					sourcemenu
					AnsiblePull
					AnsiblePush
				else
				    menu
				fi
	}

function upload()
	{
				serverhost="upload"
				serverPath="/opt/upload/"
				path="/opt/netty/upload/"
				file="upload-1.0-SNAPSHOT.jar"
				prompt "========== Are you sure update the upload?"
				if [ $? -eq 0 ];then
					sourcemenu
					AnsiblePull
					AnsiblePush
				else
				    menu
				fi
	}

function msgReceipt()
	{
				serverhost="msgReceipt"
				serverPath="/opt/msgReceipt/"
				path="/opt/netty/msgReceipt/"
				file="msgReceipt-1.0-SNAPSHOT.jar"
				prompt "========== Are you sure update the msgReceipt?"
				if [ $? -eq 0 ];then
					sourcemenu
					AnsiblePull
					AnsiblePush
				else
				    menu
				fi
	}

function appletweb()
	{
				serverhost="appletweb"
				serverPath="/opt/appletWeb/"
				path="/opt/applet/web/"
				file="appletWeb-0.0.1-SNAPSHOT.jar"
				prompt "========== Are you sure update the appletWeb?"
				if [ $? -eq 0 ];then
					sourcemenu
					AnsiblePull
					AnsiblePush
				else
				    menu
				fi
	}

function appletserver()
	{
				serverhost="appletserver"
				serverPath="/opt/appletServer/"
				path="/opt/applet/server/"
				file="appletServer-1.0.0-SNAPSHOT.jar"
				prompt "========== Are you sure update the appletServer?"
				if [ $? -eq 0 ];then
					sourcemenu
					AnsiblePull
					AnsiblePush
				else
				    menu
				fi
	}


function versionServer()
        {
                    serverhost="versionServer"
                    serverPath="/opt/version-server/"
                    path="/opt/version-server/"
                    file="versionServer-0.0.1-SNAPSHOT.jar"
                    prompt "========== Are you sure update the versionServer?"
                    if [ $? -eq 0 ];then
					sourcemenu
                            AnsiblePull
                            AnsiblePush
                    else
                        menu
                    fi
        }



function offline()
        {
                    serverhost="offline"
                    serverPath="/opt/httpOfflineServer/"
                    path="/opt/netty/httpOfflineServer/"
                    file="httpOfflineServer-1.0-SNAPSHOT.jar"
                    prompt "========== Are you sure update the offline?"
                    if [ $? -eq 0 ];then
					sourcemenu
                            AnsiblePull
                            AnsiblePush
                    else
                        menu
                    fi
        }



function msgClear()
	{
				serverhost="msgClear"
				serverPath="/opt/msgClear/"
				path="/opt/netty/msgClear/"
				file="msgClear-1.0-SNAPSHOT.jar"
				prompt "========== Are you sure update the msgClear?"
				if [ $? -eq 0 ];then
					sourcemenu
					AnsiblePull
					AnsiblePush
				else
				    menu
				fi
	}


function checkPID()
       {
               runPIDnum=`ps -ef|grep "sh update.sh"|grep -v grep|wc -l`
               if [ $runPIDnum -gt 2 ]; then
                        echo "Another process is running update.sh, Please wait until it's finished and try again"
                        exit
               fi
       }



function AnsiblePull()
        {
		echo "" >> ansible.log
                echo "------starting update $nowdata------" >> ansible.log
                ansible-playbook pull.yml --extra-vars "path=${path} file=${file}"|tee -a ansible.log
                mv ${theShelldir}/${source_ip}${path}${file} ${theShelldir}
        }

function AnsiblePush()
		{
                if [ "$serverhost" = "lexinjava" -o "$serverhost" = "upload" -o "$serverhost" = "weblogic" -o "$serverhost" = "eureka" ]; then
                    su - apple -c "ansible-playbook ${theShelldir}/supervisor_deploy.yml --extra-vars \"serverhost=${serverhost} serverPath=${serverPath} nowdata=${nowdata} file=${file}\""|tee -a ansible.log        
                else
                    su - apple -c "ansible-playbook ${theShelldir}/deploy.yml --extra-vars \"serverhost=${serverhost} serverPath=${serverPath} nowdata=${nowdata} file=${file}\""|tee -a ansible.log
                fi
        }




function main()
    {
	sed -i '/^47/d' /etc/ansible/hosts
	checkPID
	nowdata=`date +%Y%m%d-%H%M`
    theShelldir=`echo $(cd "$(dirname "$0")"; pwd)`
    menu
	rm -rf ${theShelldir}/${source_ip}
	rm -rf ${theShelldir}/${file}
	sed -i '/^47/d' /etc/ansible/hosts
    }

main $* 





