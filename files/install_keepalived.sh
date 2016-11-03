#!/bin/sh
#

if [ -f /etc/redhat-release ];then
    yum -y install keepalived
    systemctl enable keepalived
    systemctl restart keepalived
elif [ "$(grep -i ubuntu /etc/lsb-release)" ];then
    apt-get install keepalived
else
    echo "The OS detection has failed."
    exit 1
fi

