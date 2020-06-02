#!/bin/bash  
ipt=/sbin/iptables
service iptables restart

#refresh rules 
$ipt -F FORWARD
$ipt -F INPUT
$ipt -F OUTPUT 
$ipt -X
#清转发策略
$ipt  -t nat -F POSTROUTING 
$ipt  -t nat -F PREROUTING
#default policy 


$ipt -P INPUT ACCEPT 
$ipt -P FORWARD ACCEPT 
$ipt -P OUTPUT ACCEPT 

#enable loopback 
#$ipt -A INPUT -i lo -p all -j ACCEPT

#enable icmp 
#$ipt -A INPUT -p icmp -j DROP

#interface forward 


#控制单个IP的最大并发连接数为6
#$ipt -t mangle -A POSTROUTING -p tcp --syn -m connlimit --connlimit-above 6 -j LOG --log-level 4 --log-prefix "iptables: "
$ipt -t mangle -A POSTROUTING -p tcp --syn  -m connlimit --connlimit-above 500 -j DROP

#服务器每秒最多20个新连接
$ipt -A INPUT -p tcp --syn -m recent --name BAD_HTTP_ACCESS --update --seconds 60 --hitcount 20 -j REJECT 
$ipt -A INPUT -p tcp --syn -m recent  --update --seconds 60 --hitcount 20 -j REJECT
#防止SYN攻击 轻量 
$ipt -N syn-flood 
$ipt -A INPUT -p tcp --syn -j syn-flood 
$ipt -A syn-flood -p tcp -m limit --limit 3/s --limit-burst 6 -j RETURN 
$ipt -A syn-flood -j REJECT 


#防止DOS太多连接进来,可以允许外网网卡每个IP最多50个初始连接,超过的丢弃 
$ipt -A INPUT -i eth0 -p tcp --syn -m connlimit --connlimit-above 50 -j DROP 
$ipt -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT

#用Iptables抵御DDOS (参数与上相同)
$ipt -A INPUT  -p tcp --syn -m limit --limit 12/s --limit-burst 24 -j ACCEPT
$ipt -A FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT
$ipt -A INPUT -p tcp --dport 80 -m connlimit  --connlimit-above 50 -j REJECT
$ipt -A INPUT -p tcp --dport 80 -m recent --name BAD_HTTP_ACCESS --set -j ACCEPT

$ipt -A FORWARD -s 10.117.184.0/24 -j ACCEPT
$ipt -A FORWARD -d 10.117.184.0/24 -j ACCEPT


$ipt -A FORWARD -d 182.148.123.0/24 -j ACCEPT 
$ipt -A FORWARD -s 182.148.123.0/24 -j ACCEPT 

$ipt -A FORWARD -d 110.185.170.0/24 -j ACCEPT 
$ipt -A FORWARD -s 110.185.170.0/24 -j ACCEPT 

$ipt -A FORWARD -s 124.161.16.0/24 -j ACCEPT 
$ipt -A FORWARD -d 124.161.16.0/24 -j ACCEPT 


$ipt -A FORWARD -s 106.75.137.0/24 -j ACCEPT 
$ipt -A FORWARD -d 106.75.137.0/24 -j ACCEPT 

$ipt -I FORWARD -s 121.40.30.0/24 -j ACCEPT
$ipt -I FORWARD -d 121.40.30.0/24 -j ACCEPT

$ipt -I FORWARD -s 110.185.166.0/24 -j ACCEPT
$ipt -I FORWARD -d 110.185.166.0/24 -j ACCEPT

$ipt -I FORWARD -s 117.139.247.0/24 -j ACCEPT
$ipt -I FORWARD -d 117.139.247.0/24 -j ACCEPT

$ipt -I FORWARD -s 120.92.227.0/24 -j ACCEPT
$ipt -I FORWARD -d 120.92.227.0/24 -j ACCEPT

$ipt -I FORWARD -s 120.92.234.0/24 -j ACCEPT
$ipt -I FORWARD -d 120.92.234.0/24 -j ACCEPT

$ipt -I FORWARD -s 120.92.237.0/24 -j ACCEPT 
$ipt -I FORWARD -d 120.92.237.0/24 -j ACCEPT 

$ipt -I FORWARD -s 120.27.132.0/24 -j ACCEPT 
$ipt -I FORWARD -d 120.27.132.0/24 -j ACCEPT 


#server's ip
$ipt -I INPUT -s 182.148.123.0/24 -j ACCEPT
$ipt -I INPUT -s 110.185.170.0/24 -j ACCEPT
$ipt -I INPUT -s 124.161.16.0/24 -j ACCEPT
$ipt -I INPUT -s 120.26.112.0/24 -j ACCEPT
$ipt -I INPUT -d 120.26.112.0/24 -j ACCEPT
$ipt -I INPUT -s 110.185.166.0/24 -j ACCEPT
$ipt -I INPUT -s 117.139.247.0/24 -j ACCEPT


$ipt -I INPUT -s 120.55.125.0/24 -j ACCEPT
$ipt -I INPUT -s 223.5.5.5 -j ACCEPT
$ipt -I INPUT -s 223.6.6.6 -j ACCEPT
$ipt -I INPUT -s 114.114.114.114 -j ACCEPT
$ipt -I INPUT -s 8.8.8.8 -j ACCEPT
$ipt -I INPUT -s 6.6.6.6 -j ACCEPT
$ipt -I INPUT -s 121.40.30.0/24 -j ACCEPT
$ipt -I INPUT -s 121.41.29.0/24 -j ACCEPT



$ipt -I INPUT -s 120.92.237.0/24 -j ACCEPT
$ipt -I INPUT -s 120.92.234.0/24 -j ACCEPT
$ipt -I INPUT -s 120.27.132.0/24 -j ACCEPT
$ipt -I INPUT -s 120.92.227.0/24 -j ACCEPT
$ipt -I INPUT -s 10.202.72.0/24 -j ACCEPT




$ipt -t nat -A PREROUTING -p tcp --dport 8001 -j DNAT --to  120.92.237.56
$ipt -t nat -A PREROUTING -p tcp --dport 8002 -j DNAT --to  120.92.237.56
$ipt -t nat -A PREROUTING -p tcp --dport 8003 -j DNAT --to  120.92.237.56
$ipt -t nat -A PREROUTING -p tcp --dport 8004 -j DNAT --to  120.92.237.56
$ipt -t nat -A PREROUTING -p tcp --dport 9001 -j DNAT --to  120.92.237.56


$ipt -t nat -A POSTROUTING -p tcp --dport 8001 -j MASQUERADE
$ipt -t nat -A POSTROUTING -p tcp --dport 8002 -j MASQUERADE
$ipt -t nat -A POSTROUTING -p tcp --dport 8003 -j MASQUERADE
$ipt -t nat -A POSTROUTING -p tcp --dport 8004 -j MASQUERADE
$ipt -t nat -A POSTROUTING -p tcp --dport 9001 -j MASQUERADE





#save rules
#service iptables save





