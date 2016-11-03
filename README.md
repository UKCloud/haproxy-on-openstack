# haproxy-on-openstack
HEAT Template and server configuration for deploying an HA pair of haproxy servers.

To deploy:

openstack stack create -t haproxy.yaml -e environment_example.yaml --wait haproxy

Testing software deployment with os-collect-config:

openstack stack create -t test.yaml -e heat-templates\hot\software-config\boot-config\centos7_rdo_env.yaml -e environment_example.yaml --wait HAProxy