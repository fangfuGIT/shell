#!/bin/bash  
ipt=/sbin/iptables
service iptables restart

#refresh rules 
$ipt -F FORWARD
$ipt -F INPUT
$ipt -F OUTPUT 
$ipt -X

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
#$ipt -t mangle -A POSTROUTING -p tcp --syn  -m connlimit --connlimit-above 500 -j DROP

#单个IP在60秒内只允许最多20个连接
#$ipt -A INPUT -p tcp --syn -m recent --name BAD_HTTP_ACCESS --update --seconds 60 --hitcount 20 -j REJECT 
#$ipt -A INPUT -p tcp --syn -m recent  --update --seconds 60 --hitcount 20 -j REJECT

#新建一条链，限制syn的请求速度
#$ipt -N syn-flood 
#$ipt -A INPUT -p tcp --syn -j syn-flood 
#$ipt -A syn-flood -p tcp -m limit --limit 3/s --limit-burst 6 -j RETURN 
#$ipt -A syn-flood -j DROP 
#limit --limit 3/s 每秒平均流量是否超过一次 3 个封包
#--limit-burst 限制特定包瞬间传入的数量，6个

#$ipt -A INPUT -p tcp --syn -m connlimit --connlimit-above 50 -j DROP
#限制所有tcp端口，同一IP同时最多连50个
#$ipt -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT

#$ipt -A INPUT  -p tcp --syn -m limit --limit 12/s --limit-burst 24 -j ACCEPT
#$ipt -A FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT
#限制所有tcp端口通过INPUT链平均流量是否超过每秒12个，一次24个包
#限制所有tcp端口通过FORWORD链平均流量是否超过每秒1个
$ipt -A INPUT -p tcp --dport 80 -m connlimit  --connlimit-above 50 -j REJECT
#限制80端口同一IP同时最多连50个
#$ipt -A INPUT -p tcp --dport 80 -m recent --name BAD_HTTP_ACCESS --set -j ACCEPT

#DNS
$ipt -I INPUT -s 222.209.233.31 -j ACCEPT
$ipt -I INPUT -s 223.5.5.5 -j ACCEPT
$ipt -I INPUT -s 223.6.6.6 -j ACCEPT
$ipt -I INPUT -s 114.114.114.114 -j ACCEPT
$ipt -I INPUT -s 8.8.8.8 -j ACCEPT
$ipt -I INPUT -s 6.6.6.6 -j ACCEPT

#server
$ipt -I INPUT -s 34.87.7.215 -j ACCEPT
$ipt -I INPUT -s 103.120.83.62 -j ACCEPT
$ipt -I INPUT -s 103.108.195.247 -j ACCEPT
$ipt -I INPUT -s 103.108.195.233 -j ACCEPT
$ipt -I INPUT -s 192.168.195.0/24 -j ACCEPT

$ipt -A INPUT -p tcp --dport 80 -j ACCEPT
$ipt -A INPUT -p tcp --sport 80 -j ACCEPT
$ipt -A INPUT -p tcp --dport 92 -j ACCEPT
$ipt -A INPUT -p tcp --dport 82 -j ACCEPT
$ipt -A INPUT -p tcp --sport 82 -j ACCEPT
$ipt -A INPUT -p tcp --dport 22000 -j ACCEPT
$ipt -A INPUT -p tcp --dport 8090 -j ACCEPT           
$ipt -A INPUT -p tcp --sport 8090 -j ACCEPT           
$ipt -A INPUT -p tcp --sport 22000 -j ACCEPT           
$ipt -A INPUT -p udp --sport 53 -j ACCEPT           
$ipt -A INPUT -p udp --sport 161 -j ACCEPT          
$ipt -A INPUT -p udp --sport 123 -j ACCEPT  

$ipt -t nat -A PREROUTING -p tcp --dport 80 -j LOG --log-level notice --log-prefix "PREROUTING 80 PORT: "
#$ipt -t nat -A PREROUTING -p tcp --dport 80 -m state --state NEW -m statistic --mode nth --every 3 --packet 0 -j DNAT --to-destination 193.112.72.19:80
#$ipt -t nat -A PREROUTING -p tcp --dport 80 -m state --state NEW -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 192.168.195.247:82
$ipt -t nat -A PREROUTING -p tcp --dport 80 -m state --state NEW -m statistic --mode nth --every 1 --packet 0 -j DNAT --to-destination 34.87.7.215:8090

#$ipt -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to 34.87.7.215:8090
$ipt -t nat -A POSTROUTING -j MASQUERADE

#save rules
service iptables save
