#SCRIPT_NAME:  weixin.sh
#DESCRIPTION:  send message from weixin for zabbix monitor
#!/bin/bash
CropID='wwe1f9cb07031dd4df'    # 我的企业的CorpID
Secret='NR2h-W3tZd2TOHS9KjtBZ-QSjz2RzVk9_jTC0ikpeg4'    # 创建应用时的Secret
#获取access_token
GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CropID&corpsecret=$Secret"
Gtoken=$(/usr/bin/curl -s -G $GURL | awk -F\" '{print $10}')
PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$Gtoken"
function body () {
   local int AppId=1000002   #应用的id
   local UserId=$1           #发送的用户位于$1字符串
   local PartyId=1           # 通讯录中部门的ID
   local Meg=$(echo "$@" | cut -d" " -f3-)
   echo """{
    \"touser\" : \"$UserId\",
    \"toparty\" : \"$PartyId\",
    \"msgtype\" : \"text\",
    \"agentid\" : \"$AppId\",
    \"text\" : {
        \"content\" : \"$Meg\"}
}"""
}
/usr/bin/curl --data-ascii "$(body $1 $2 $3)" $PURL