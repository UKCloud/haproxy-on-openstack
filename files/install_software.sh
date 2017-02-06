#!/bin/sh
#

if [ -f /etc/redhat-release ];then
    yum -y install haproxy

    #sysctl -w net.ipv4.ip_forward=1
    #sysctl -w net.ipv4.ip_nonlocal_bind=1

    systemctl enable haproxy
    systemctl restart haproxy
elif [ "$(grep -i ubuntu /etc/lsb-release)" ];then
    apt-get install haproxy
else
    echo "The OS detection has failed."
    exit 1
fi

if [ "$deploy_consul" -eq "true" ]; then
    DOWNLOAD_URL="https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip"

    yum -y install wget unzip

    wget -O /tmp/consul.zip $DOWNLOAD_URL
    mkdir -p /usr/local/bin
    cd /usr/local/bin
    unzip /tmp/consul.zip
    mkdir -p /etc/consul.d/
    mkdir -p /var/consul
    useradd --comment "Consul User" --no-create-home --system --shell /sbin/nologon consul
    chown consul.consul /var/consul

    systemctl enable consul
    systemctl restart consul
fi