<<<<<<< HEAD
# Configuration Management Automation with Ansible

This repository contains the starter code intended for the coursework in ACS730
Cloud Automation & Control Systems course at Seneca College.

In the DevOps and SRE field, you will be asked to deploy, configure and manage
software unfamiliar to you. In this assignment, you will automate the
deployment of a Kubernetes cluster running on AWS using Ansible.

## Objective

Your goal is to deploy a Kubernetes cluster on AWS using Ansible. Given the
installation scripts, you will migrate the installation procedure to Ansible.

## Requirements

The final state of the automation should allow the following:

- Deploy a Kubernetes cluster onto the provided infrastructure by running a single Ansible playbook.
- Discover nodes in the cluster using dynamic inventory.
- Proxy SSH connections to the cluster nodes using the bastion host without code changes.
- Run a simple static web service on the cluster nodes.

## Getting Started

Infrastructure for the Kubernetes cluster is provided in the `terraform`
directory. See the README.md file in that directory for instructions on how to
deploy the infrastructure.

Scripts to install Kubernetes is provided in the `scripts` directory. See the
README.md file in that directory for instructions on how to configure
Kubernetes.

## Reverting the Kubernetes installation

To remove Kubernetes from the node, run the following command:

```bash
sudo kubeadm reset
```

## Proxying an SSH connection via a bastion host

You can connect directly to an instance via a bastion host by using the `ProxyCommand` option.

```bash
export BASTION_IP=<Public IP address of the bastion host>
export NODE_IP=<Private IP address of the node>
export BASTION_KEY=<Path to the bastion host SSH private key>
export NODE_KEY=<Path to the node SSH private key>
ssh -i $NODE_KEY -o Proxycommand="ssh -i $BASTION_KEY -W %h:%p ec2-user@$NODE_IP" ec2-user@$NODE_IP
```

## Running a simple nginx webserver on the cluster

In this cluster, the bastion host will be used to control the cluster. SSH into
the bastion host and run the following commands:

```bash
# Check all the available nodes as a sanity check
$ kubectl get nodes
NAME                         STATUS   ROLES           AGE   VERSION
ip-10-0-10-36.ec2.internal   Ready    control-plane   26m   v1.26.10
ip-10-0-10-98.ec2.internal   Ready    <none>          55s   v1.26.10

# Create an nginx deployment
$ kubectl create deployment nginx --image=nginx
deployment.apps/nginx created

# View deployments
$ kubectl get deployments
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   1/1     1            1           22s

# Expose the deployment as a service
$ kubectl create service nodeport nginx --tcp=80:80
service/nginx created

# View services
$ kubectl get services
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP        3h38m
nginx        NodePort    10.108.160.170   <none>        80:32163/TCP   22s

# Make a request to the worker node on the specified port. In this example, you will use port 32163.
$ curl 10.0.10.98:32163
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...

# Delete the deployment
$ kubectl delete deployment nginx
deployment.apps "nginx" deleted
```
=======
# ansible_playbook
Ansible_playbook
>>>>>>> origin/main
