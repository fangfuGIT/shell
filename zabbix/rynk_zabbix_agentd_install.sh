#!/bin/bash
#Desc:Install Zabbix_agentd
#Date:2018-04-02
#Author:Fang


function Check (){  
    Agentd=/usr/local/zabbix/sbin/zabbix_agentd
    if test -e $Agentd && "$Agentd" -V2 | grep 4.2 > /dev/null
	then
    echo "Zabbix_agentd 4.2 has been already installed. Exit" && exit
    else
    test -f zabbix_agentd_install.sh && rm -f zabbix_agentd_install.sh
    test -f /usr/local/zabbix/sbin/zabbix_agentd && rm -rf /usr/local/zabbix/sbin/zabbix_agentd
    test -f /etc/init.d/zabbix_agentd && rm -f /etc/init.d/zabbix_agentd
    fi
}
#配置相关
function Config(){  
    Server=$1
    IP="`ifconfig | grep -o 'inet [0-9.]*' | grep -o '[0-9.]*$' | grep -e '^192\.' -e '^10\.' -e '^172\.'`"   #内网IP获取
	#IP="`curl ip.6655.com/ip.aspx`"    #公网IP获取
    mkdir -p /usr/local/zabbix/sbin/
    mkdir -p /usr/local/zabbix/etc/
    mkdir -p /var/log/zabbix/ && touch /var/log/zabbix/zabbix_agentd.log
    chown zabbix:zabbix /var/log/zabbix/zabbix_agentd.log && chmod 755 /var/log/zabbix/zabbix_agentd.log
    cd /usr/local/zabbix/sbin/
 
cat > /usr/local/zabbix/etc/zabbix_agentd.conf <<EOF
Server=${Server}
Hostname=${IP}
ServerActive=${Server}:10051
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=10
BufferSize=1024
EOF

}

function Install(){
    yum install -y gcc pcre*
    wget http://35.198.217.74:8088/09/mc/drum/zabbix-4.2.3.tar.gz
	tar zxvf zabbix-4.2.3.tar.gz && cd zabbix-4.2.3    
    ./configure --prefix=/usr/local/zabbix --enable-agent && make && make install
    echo 'zabbix-agent 10050/tcp # Zabbix Agent'>>/etc/services
    echo 'zabbix-agent 10050/udp # Zabbix Agent'>>/etc/services
    cp misc/init.d/fedora/core/zabbix_agentd /etc/init.d/
    sed -i "s#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix#g" /etc/init.d/zabbix_agentd
    chkconfig --add zabbix_agentd
    chkconfig zabbix_agentd on
    chmod +x /etc/init.d/zabbix_agentd
    chmod +x /usr/local/zabbix/sbin/zabbix_agentd
    groupadd zabbix
    useradd -g zabbix zabbix -s /bin/false
    Config $1
    service zabbix_agentd start && chkconfig zabbix_agentd on
    rm -rf ~/zabbix-4.2.0 && rm -rf ~/zabbix-4.2.0.tar.gz
    
    echo ---------------------Result---------------------------------
	
    netstat -ntlp | grep zabbix_agentd && echo -e "\033[33minstall Succeed.\033[0m" || echo -e "\033[31minstall Failed.\033[0m"
}

if [ -z $1 ]
then
    Server="10.148.0.8" 
else
    Server=$1
fi
#main
Check
Install $Server  
