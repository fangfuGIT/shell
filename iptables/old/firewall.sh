#!/bin/bash 
#define string 
ipt=/sbin/iptables 

#refresh rules 
$ipt -F FORWARD
$ipt -F INPUT
$ipt -F OUTPUT 
$ipt -X

#default policy 
$ipt -P INPUT DROP 
$ipt -P FORWARD DROP 
$ipt -P OUTPUT ACCEPT 

#enable loopback 
$ipt -A INPUT -i lo -p all -j ACCEPT

#enable icmp a
$ipt -A INPUT -p icmp -j ACCEPT

#interface forward 
#$ipt -A FORWARD -s 192.168.1.0/24 -j ACCEPT
#$ipt -A FORWARD -d 192.168.1.0/24 -j ACCEPT 

#company's ip
$ipt -A INPUT -s 182.151.214.182 -j ACCEPT
$ipt -A INPUT -s 119.6.21.230 -j ACCEPT
$ipt -A INPUT -s 210.14.141.158 -j ACCEPT
$ipt -A INPUT -s 117.79.239.243 -j ACCEPT
$ipt -A INPUT -s 117.79.239.248 -j ACCEPT
$ipt -A INPUT -s 101.69.167.195 -j ACCEPT
$ipt -A INPUT -s 206.209.110.2 -j ACCEPT
$ipt -A INPUT -s 117.79.237.140 -j ACCEPT
$ipt -A INPUT -s 182.140.132.169 -j ACCEPT
$ipt -A INPUT -s 192.168.8.0/24 -j ACCEPT
$ipt -A INPUT -s 192.168.2.0/24 -j ACCEPT
$ipt -A INPUT -s 172.16.11.0/24 -j ACCEPT
$ipt -A INPUT -s 172.16.10.0/24 -j ACCEPT
$ipt -A INPUT -s 172.15.11.0/24 -j ACCEPT
$ipt -A INPUT -s 172.15.10.0/24 -j ACCEPT
$ipt -A INPUT -s 129.7.1.66 -j ACCEPT
$ipt -A INPUT -s 118.194.62.0/24 -j ACCEPT
$ipt -A INPUT -s 210.14.158.0/24 -j ACCEPT
$ipt -A INPUT -s 210.14.135.105 -j ACCEPT

#
$ipt -A INPUT -p tcp --sport 80 -j ACCEPT                         
$ipt -A INPUT -p tcp --dport 80 -j ACCEPT   
$ipt -A INPUT -p udp --sport 53 -j ACCEPT           
$ipt -A INPUT -p udp --sport 161 -j ACCEPT          
$ipt -A INPUT -p udp --sport 123 -j ACCEPT                          



#save rules
service iptables save
