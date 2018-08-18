#!/bin/bash

apt-get install figlet
echo -e " \033[1;31m------------------------------------------------------\033[1;36m"
echo -e " \033[1;31mBy @Adm_sarah\033[1;36m"
echo "          ConectaBrasilVps" | figlet
echo -e " \033[1;31m------------------------------------------------------\033[1;36m"
sleep 6

tput setaf 8 ; tput setab 5 ; tput bold ; printf '%30s%s%-15s\n' "INSTALANDO SSHPLUS" ; tput sgr0
echo -e "\033[1;34m INSTALANDO...\033[1;32m"

apt-get install squid3 bc screen nano unzip dos2unix -y > /dev/null 2>&1
apt-get install nload -y > /dev/null 2>&1
apt-get install screen -y > /dev/null 2>&1
apt-get install jq -y > /dev/null 2>&1
apt-get install curl -y > /dev/null 2>&1
apt-get install figlet -y > /dev/null 2>&1
apt-get install python3 -y > /dev/null 2>&1
apt-get install python-pip -y > /dev/null 2>&1
pip install speedtest-cli > /dev/null 2>&1

clear

sed -i '3i\127.0.0.1 portalrecarga.vivo.com.br\' /etc/hosts
sed -i '3i\127.0.0.1 portalrecarga.vivo.com.br\recarga\' /etc/hosts
sed -i '3i\127.0.0.1 navegue.vivo.com.br\pre\' /etc/hosts
sed -i '3i\127.0.0.1 sdp.vivo.com.br\\' /etc/hosts

cd /bin

wget https://www.dropbox.com/s/f4fq7idmt2d5c31/ssh.zip && unzip ssh.zip && chmod -R 777 * && rm ssh.zip
cd /etc

clear
if [ $(id -u) -eq 0 ]
then
	clear
else
	if echo $(id) |grep sudo > /dev/null
	then
	clear
	echo -e "\033[1;37mVoce n?o e root"
	echo -e "\033[1;37mSeu usuario esta no grupo sudo"
	echo -e "\033[1;37mPara virar root execute \033[1;31msudo su\033[1;37m ou execute \033[1;31msudo $0\033[0m"
	exit
	else
	clear
	echo -e "Vc nao esta como usuario root, nem com seus direitos (sudo)\nPara virar root execute \033[1;31msu\033[0m e digite sua senha root"
	exit
	fi
fi

cat -n /etc/issue |grep 1 |cut -d' ' -f6,7,8 |sed 's/1//' |sed 's/	//' > /etc/so 
echo -e "\033[1;31mPara a instalacao ser correta e preciso o ip.
Digite o ip !\033[0m"
read -p ": " ip
clear

echo -e "\033[1;31m-----> \033[01;37mSeu sistema operacional:\033[1;31m $(cat /etc/so)"
echo -e "\033[1;31m-----> \033[01;37mSeu ip:\033[1;31m $ip"
echo -e "\033[1;31m-----> \033[1;37mSQUID NAS PORTAS:\033[1;31m 80, 8080, 8799 e 3128\033[0m"
echo -e "\033[1;31m-----> \033[1;37mSSH NAS PORTAS: \033[1;31m443 e 22\033[0m"
echo -e "\033[1;31m-----> \033[1;37mSSH NOS IPS: \033[1;31m$ip, localhost e 127.0.0.1\033[0m"

function sshd_config(){ echo "Port 22
Port 443
Protocol 2
KeyRegenerationInterval 3600
ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin yes
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication yes
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes" > /etc/ssh/sshd_config
}

function addhost(){ echo '#!/bin/bash
echo "Qual host deseja adicionar ?"
read -p ": " host
echo "$host" >> /etc/payloads
squid -k reconfigure > /dev/null 2> /dev/null
squid3 -k reconfigure > /dev/null 2> /dev/null
echo "$host Adicionado" ' > /bin/addhost
chmod a+x /bin/addhost
}

function payloads(){ echo "minhaclaro.claro.com.br
recargafacil.claro.com.br
frontend.claro.com.br
appfb.claro.com.sv
empresas.claro.com.br
d1n212ccp6ldpw.cloudfront.net
claro-gestoronline.claro.com.br
forms.claro.com.br
golpf.claro.com.br
logtiscap.claro.com.br
www.recargafacil.claro.com.br
global-4-lvs-colossus-5.opera-mini.net.prancis.nut.cc/
ecob.claro.com.br
.vivo.com.br
.bradescocelular.com.br
.claroseguridad.com" > /etc/payloads
}

if cat /etc/so |grep -i ubuntu |grep 16 1> /dev/null 2> /dev/null ; then
echo -e "\033[1;37mConfigurando, Aguarde...\033[0m"
apt-get update 1> /dev/null 2> /dev/null
apt-get install -y squid3 1> /dev/null 2> /dev/null

service apache2 stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service ssh restart 1> /dev/null 2> /dev/null

echo "http_port 80
http_port 8799
http_port 3128
visible_hostname PackSSH
acl ip dstdomain $ip
http_access allow ip" > /etc/squid/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid/squid.conf

addhost

echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando addhost
os hosts ficam no arquivo /etc/payloads\033[0m"
payloads
service squid restart 1> /dev/null 2> /dev/null

echo -e "\033[0;34m-------------------------------------------------\033[0m"
echo -e "         \033[1;33m? \033[1;32mINSTALACAO CONCLUIDA \033[1;33m?\033[0m"
echo ""
echo -e "\033[1;31m? \033[1;33mProxy Squid Instalado, Portas: 80, 8080, 3128\033[0m"
echo -e "\033[1;31m? \033[1;33mOpenSSH rodando nas portas 22 e 443\033[0m"
echo -e "\033[1;31m? \033[1;33mScript para gerenciamento de usuarios instalado\033[0m"
echo -e "\033[1;31m? \033[1;33mComandos disponiveis Execute \033[1;32mmenu \033[1;33mou \033[1;32majuda\033[0m"
echo -e "\033[0;34m-------------------------------------------------\033[0m"exit 0
fi

if cat /etc/so |grep -i ubuntu 1> /dev/null 2> /dev/null ; then
echo -e "\033[1;37mConfigurando, Aguarde...\033[0m"
apt-get update 1> /dev/null 2> /dev/null
apt-get install -y squid3 1> /dev/null 2> /dev/null

service apache2 stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service ssh restart 1> /dev/null 2> /dev/null

echo "http_port 80
http_port 8799
http_port 3128
visible_hostname VpsPack
acl ip dstdomain $ip
http_access allow ip" > /etc/squid3/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid3/squid.conf
payloads
service squid3 restart 1> /dev/null 2> /dev/null
addhost

echo -e "\033[0;34m-------------------------------------------------\033[0m"
echo -e "         \033[1;33m? \033[1;32mINSTALACAO CONCLUIDA \033[1;33m?\033[0m"
echo ""
echo -e "\033[1;31m? \033[1;33mProxy Squid Instalado, Portas: 80, 8080, 3128\033[0m"
echo -e "\033[1;31m? \033[1;33mOpenSSH rodando nas portas 22 e 443\033[0m"
echo -e "\033[1;31m? \033[1;33mScript para gerenciamento de usuarios instalado\033[0m"
echo -e "\033[1;31m? \033[1;33mComandos disponiveis Execute \033[1;32mmenu \033[1;33mou \033[1;32majuda\033[0m"
echo -e "\033[0;34m-------------------------------------------------\033[0m"
exit 0
fi

if cat /etc/so |grep -i centos 1> /dev/null 2> /dev/null ; then
echo -e "\033[01;37mConfigurando, Aguarde...\033[0m"
yum -y update 1> /dev/null 2> /dev/null
yum install -y squid 1> /dev/null 2> /dev/null

service httpd stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service sshd restart 1> /dev/null 2> /dev/null

echo "http_port 80
http_port 8799
http_port 3128
visible_hostname VpsPack
acl ip dstdomain $ip
http_access allow ip" > /etc/squid/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid/squid.conf
payloads
service squid restart 1> /dev/null 2> /dev/null
addhost

echo -e "\033[0;34m-------------------------------------------------\033[0m"
echo -e "         \033[1;33m? \033[1;32mINSTALACAO CONCLUIDA \033[1;33m?\033[0m"
echo ""
echo -e "\033[1;31m? \033[1;33mProxy Squid Instalado, Portas: 80, 8080, 3128\033[0m"
echo -e "\033[1;31m? \033[1;33mOpenSSH rodando nas portas 22 e 443\033[0m"
echo -e "\033[1;31m? \033[1;33mScript para gerenciamento de usuarios instalado\033[0m"
echo -e "\033[1;31m? \033[1;33mComandos disponiveis Execute \033[1;32mmenu \033[1;33mou \033[1;32majuda\033[0m"
echo -e "\033[0;34m-------------------------------------------------\033[0m"
exit
fi

if cat /etc/so |grep -i debian 1> /dev/null 2> /dev/null ; then
echo -e "\033[01;37mConfigurando, Aguarde...\033[0m"
apt-get update 1> /dev/null 2> /dev/null
apt-get install -y squid3 1> /dev/null 2> /dev/null
service apache2 stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config

service ssh restart 1> /dev/null 2> /dev/null

echo "http_port 80
http_port 8799
http_port 3128
visible_hostname VpsPack
acl ip dstdomain $ip
http_access allow ip" > /etc/squid3/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid3/squid.conf
payloads
service squid3 restart 1> /dev/null 2> /dev/null
addhost

echo -e "\033[0;34m-------------------------------------------------\033[0m"
echo -e "         \033[1;33m? \033[1;32mINSTALACAO CONCLUIDA \033[1;33m?\033[0m"
echo ""
echo -e "\033[1;31m? \033[1;33mProxy Squid Instalado, Portas: 80, 8080, 3128\033[0m"
echo -e "\033[1;31m? \033[1;33mOpenSSH rodando nas portas 22 e 443\033[0m"
echo -e "\033[1;31m? \033[1;33mScript para gerenciamento de usuarios instalado\033[0m"
echo -e "\033[1;31m? \033[1;33mComandos disponiveis Execute \033[1;32mmenu \033[1;33mou \033[1;32majuda\033[0m"
echo -e "\033[0;34m-------------------------------------------------\033[0m"
exit 0
fi



if cat /etc/issue |grep -i kernel 1> /dev/null 2> /dev/null ; then
echo -e "\033[01;31mConfigurando, Aguarde...\033[0m"
yum -y update 1> /dev/null 2> /dev/null
yum install -y squid 1> /dev/null 2> /dev/null

service httpd stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service sshd restart 1> /dev/null 2> /dev/null

echo "http_port 80
http_port 8799
http_port 3128
visible_hostname PackSSH
acl ip dstdomain $ip
http_access allow ip" > /etc/squid/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid/squid.conf
payloads
service squid restart 1> /dev/null 2> /dev/null
addhost

echo -e "\033[0;34m-------------------------------------------------\033[0m"
echo -e "         \033[1;33m? \033[1;32mINSTALACAO CONCLUIDA \033[1;33m?\033[0m"
echo ""
echo -e "\033[1;31m? \033[1;33mProxy Squid Instalado, Portas: 80, 8080, 3128\033[0m"
echo -e "\033[1;31m? \033[1;33mOpenSSH rodando nas portas 22 e 443\033[0m"
echo -e "\033[1;31m? \033[1;33mScript para gerenciamento de usuarios instalado\033[0m"
echo -e "\033[1;31m? \033[1;33mComandos disponiveis Execute \033[1;32mmenu \033[1;33mou \033[1;32majuda\033[0m"
echo -e "\033[0;34m-------------------------------------------------\033[0m"
exit
fi

echo -e "\033[01;31mConfigurando, Aguarde...\033[0m"

yum -y update 1> /dev/null 2> /dev/null
yum install -y squid 1> /dev/null 2> /dev/null
apt-get update > /dev/null 2> /dev/null
apt-get install -y squid3 > /dev/null 2>/dev/null
service httpd stop 1> /dev/null 2> /dev/null
service apache2 stop >/dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service sshd restart 1> /dev/null 2> /dev/null
service ssh restart > /dev/null 2> /dev/null
echo "http_port 80
http_port 8799
http_port 3128
visible_hostname PackSSH
acl ip dstdomain $ip
http_access allow ip" > /etc/squid*/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid*/squid.conf
payloads
service squid restart 1> /dev/null 2> /dev/null
service squid3 restart > /dev/null 2> /dev/null
addhost
echo -e "\033[0;34m-------------------------------------------------\033[0m"
echo -e "         \033[1;33m? \033[1;32mINSTALACAO CONCLUIDA \033[1;33m?\033[0m"
echo ""
echo -e "\033[1;31m? \033[1;33mProxy Squid Instalado, Portas: 80, 8080, 3128\033[0m"
echo -e "\033[1;31m? \033[1;33mOpenSSH rodando nas portas 22 e 443\033[0m"
echo -e "\033[1;31m? \033[1;33mScript para gerenciamento de usuarios instalado\033[0m"
echo -e "\033[1;31m? \033[1;33mComandos disponiveis Execute \033[1;32mmenu \033[1;33mou \033[1;32majuda\033[0m"
echo -e "\033[0;34m-------------------------------------------------\033[0m"


history -c && history -w

cd

clear
