# Kubernetes Cluster Setup

*Ansible* playbook to setup a *Kubernetes* cluster

## Requirements

All installation and configuration routines are automated. There some requirements for host machines.

### Linux

Each machine should be with *Linux* installed (latest *Ubuntu LTS* is preferred). Minimal *kernel* version is **3.19**.

### Availability

All servers should be in one subnetwork and all ports should be oped in foll all these hosts.
Each host should accept incoming traffic for **port 22** to allow *Ansible* connect and make installation.
And you sould add you *SSH* public key to *~/.ssh/authorized_keys* on each host for user you will use to connect during installation.

### Python

Python should be installed on each cluster host to run *Ansible* scripts

```bash
apt-get install python python-pip
```

### Ansible

Install *Ansible* on host you will use to run installer (your localhost usually). Minimal *Ansible* version is 2.0.0.2, tested up to 2.1.0.0.

```bash
pip install ansible==2.0.0.2 netaddr
```

## Configuring Ansible Playbooks

There is a few options to configure before running this playbooks.
Directory tree describes files with configuration variables:

```
ansible
|_ group_vars/
  |_ all.yml # global variables for all roles
|_ roles/
  |_ <role_name>
    |_ defaults/
      |_ main.yml # role specific configuration variables
```

```bash
vim ansible/group_vars/all.yml
```

```yaml
ansible_ssh_user: ubuntu
# Use this SSH user to login on the remote server.

kube_service_addresses: 10.254.0.0/16
# Kubernetes internal network for services.
# Kubernetes services will get fake IP addresses from this range.
# This range must not conflict with anything in your infrastructure. These
# addresses do not need to be routable and must just be an unused block of space.

flannel_subnet: 172.16.0.0
# Flannel internal network (optional). When flannel is used, it will assign IP
# addresses from this range to individual pods.
# This network must be unused in your network infrastructure!
```

```bash
vim ansible/inventory
```

```ini
[masters]
10.63.0.1

[etcd:children]
masters
nodes

[nodes]
10.63.0.11
10.63.0.12

[nodes:children]

```

## Sections description
```
[masters]
```
Write in this section hosts you want to use as masters.

```
[nodes]
```
Hosts that you want to be used as nodes.

```
[etcd:children]
```
Hosts to be used for etcd cluster. The good point to use master and nodes for this purpose.


## Providing root access on hosts

This playbooks requires that your user have a ssh access with key authorization on remote hosts.


## Creating cluster

Now you ready to create your kubernetes cluster. All you have to do is to run "create_cluster.sh"

```shell
./ansible/create_cluster.sh
```

