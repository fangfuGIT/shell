#! /bin/bash





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
        echo "-------------------------------"
        echo "please choose the server which need to change nginx configuration："
        echo "(1) only close 10.148.0.83"
        echo "(2) only close 10.148.0.84"
        echo "(3) open all (83 + 84) "
        echo "(4) exit"
        echo "-------------------------------"
        read input
        case $input in
                1)
                server83;;
                2)
                server84;;
          	3)
		serverall;;
                4)
                exit;;
                *)
                menu;;
        esac
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
				echo "========== will shield and close nginx abount 10.148.0.83"
                                prompt "========== Are you sure change all nginx configuration and reload nginx ?"
                                if [ $? -eq 0 ];then
                                    su - apple -c "ansible-playbook ${theShelldir}/nginx_deploy.yml --extra-vars \"serverhost=${serverhost_tcps} serverPath=${serverPath} fileA=${fileA} fileB=${fileB}\""|tee -a ansible.log
                                    su - apple -c "ansible-playbook ${theShelldir}/nginx_deploy.yml --extra-vars \"serverhost=${serverhost_eureka} serverPath=${serverPath} fileA=${fileC} fileB=${fileD}\""|tee -a ansible.log
                                else
                                    menu
                                fi
				rm -rf ${theShelldir}/*.conf

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
                                echo "========== will shield and close nginx abount 10.148.0.84"
                                prompt "========== Are you sure change all nginx configuration and reload nginx ?"
                                if [ $? -eq 0 ];then
                                    su - apple -c "ansible-playbook ${theShelldir}/nginx_deploy.yml --extra-vars \"serverhost=${serverhost_tcps} serverPath=${serverPath} fileA=${fileA} fileB=${fileB}\""|tee -a ansible.log
                                    su - apple -c "ansible-playbook ${theShelldir}/nginx_deploy.yml --extra-vars \"serverhost=${serverhost_eureka} serverPath=${serverPath} fileA=${fileC} fileB=${fileD}\""|tee -a ansible.log
                                else
                                    menu
                                fi
				rm -rf ${theShelldir}/*.conf
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

function main()
    {
        nowdata=`date +%Y%m%d-%H%M`
        theShelldir=`echo $(cd "$(dirname "$0")"; pwd)`
        menu
    }

main $* 
