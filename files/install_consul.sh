#!/bin/sh
#

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
