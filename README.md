# Deploying an HA pair of HAProxy Servers

This repository contains HEAT Orchestration Templates to build and configure a pair of servers, each with HAProxy installed and configured. They also use keepalived to manage a Virtual IP address in an active / passive configuration.

The template sets up the required OpenStack configurations of ports and floating IP address, along with the 'allowed address pairs' configuration on the two instances, allowing the mapping of a floating IP address to the VIP controlled by keepalived.

Additionally, the template creates a ServerGroup resource with an 'anti-affinity' scheduler policy, ensuring that the two HAProxy instances are deployed onto different hypervisor hosts.

----------

The `haproxy.yaml` template assumes that you already have a minimal environment configured in your OpenStack project, including a router connected to your external 'internet' network,
and an existing 'Jumpbox' server providing external connectivity into the project. 

If you do not yet have any infrastructure components deployed into your project, you can choose to deploy the `jumpbox.yaml`  stack by updating the `environment_jumpbox.yaml` file with
appropriate values for your desired infrastructure. The only entry you are required to change is `key_name` which should be set to the name of an SSH Keypair you have already configured in your project. All the other values in `environment_jumpbox.yaml` may be left as their default values.

To deploy the jumpbox and minimal infrastructure, run:
```
openstack stack create -t jumpbox.yaml -e environment_jumpbox.yaml --wait jumpbox
```

Once the stack is complete, you will be able to login to the jumpbox server:
```
ssh centos@<floating ip> -i ~/.ssh/mykey.private
```
----------
Before deploying the `haproxy.yaml` stack, you will want to edit the `environment_example.yaml` configuration file. 

If your backend nodes are already deployed, then you will also need to update the haproxy configuration file in `files/haproxy.cfg` to reflect the number of servers in your cluster. If your backend nodes are not yet deployed, don't worry - you can deploy an updated `haproxy.cfg` configuration to the pair of servers by performing a stack update.

Deploy the pair of HAProxy servers by running:
```
openstack stack create -t haproxy.yaml -e environment_example.yaml --wait haproxy
```
To re-deploy the haproxy configuration any time after updating the `files/haproxy.cfg` file, you can run:
```
openstack stack update -t haproxy.yaml -e environment_example.yaml --wait haproxy
```
The stack update will not re-deploy the instances. It uses the `os-collect-config` SoftwareConfiguration resources to push out the updated config and then reload HAProxy with the new settings.

----------

### TODO:
 - [x] Deploy HA cluster of HAProxy instances
 - [x] Automated deployment of HAProxy configuration
 - [X] Update to work with OpenStack Netwon
 - [ ] Write script to allow easier enviroment file creation
 - [ ] Make stack more configurable
 - [ ] Add OpenSSL certificate deployment and https configuration for HAProxy instances
 - [ ] Deploy Consul for service discovery and automated configuration of HAProxy

License and Authors
-------------------
Authors:
  * Rob Coward (rcoward@ukcloud.com)

Copyright 2017 UKCloud

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
