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

## Configure Ansible inventory

You should prepare *Ansible* inventory (`ansible/inventory` file) to configure hosts before running intaller.

### Inventory

Use our example as a template for your inventory

```bash
cp ansible/inventory.example ansible/inventory
vim ansible/inventory
```

You configuration should looks like this

```ini
[masters]
# List of Kubernetes master nodes hosts.
10.63.0.1

[nodes]
# Hosts you want to use as Kubernetes nodes.
10.63.0.11
10.63.0.12

[etcd:children]
# Hosts to use for etcd cluster.
# Add master and nodes hosts for high availablility.
masters
nodes
```

### Playbook group_vars customization

In some rare cases you have to edit default *group_vars* at `ansible/group_vars/all.yml`.
Here is highlights

#### SSH user

User to login on the remote server with SSH.

```yaml
ansible_ssh_user: ubuntu
```

#### Kubernetes network

Kubernetes internal network for services.
Kubernetes services will get fake IP addresses from this range.
This range should not conflict with anything in your infrastructure.
These addresses do not need to be routable and should be just an unused block of space.

```yaml
kube_service_addresses: 10.254.0.0/16
```

#### Flannel subnet

Flannel internal network.
Flannel will assign IP addresses from this range to individual pods.
This network should not be used in your network infrastructure!

```yaml
flannel_subnet: 172.16.0.0
```

## Create a cluster

You can create a cluster with a single script

```bash
./ansible/create_cluster.sh
```

`ubuntu` user is used to ssh to remote hosts by default, you could change it by passing extra variable for *Ansible*


```bash
./ansible/create_cluster.sh -e ansible_ssh_user=my_user
```

## Access the cluster

Cluster installer produces `kubeconfig.yml` in `cwd`. It can be used to access the cluster with `kubectl`.

```bash
kubectl --kubeconfig=kubeconfig.yml cluster-info
```
