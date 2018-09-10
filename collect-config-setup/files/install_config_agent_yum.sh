#!/bin/bash
#set -eux

# on Atomic host os-collect-config runs inside a container which is
# fetched&started in another step
[ -e /run/ostree-booted ] && exit 0

if ! yum info os-collect-config; then
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python get-pip.py
  yum install -y git python-devel
  yum groupinstall -y "Development Tools"
  #TODO workout the odd dependancies that cuase this to fail
  yum remove -y PyYAML
  yum remove -y python-requests
  pip install -U git+git://git.openstack.org/openstack/os-apply-config.git
  pip install -U git+git://git.openstack.org/openstack/os-collect-config.git
  pip install -U git+git://git.openstack.org/openstack/os-refresh-config.git
  yum install -y http://vault.centos.org/7.4.1708/cloud/x86_64/openstack-newton/openstack-heat-templates-0-0.5.1e6015dgit.el7.noarch.rpm
  yum install -y cloud-init
fi
