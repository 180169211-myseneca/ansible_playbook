# Kubernetes Cluster Deployment

## Overview
This guide provides step-by-step instructions for configuring pre-provisioned resources and deploying a Kubernetes cluster using Ansible playbooks. Kubernetes is a widely-used open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications. It simplifies complex tasks related to container orchestration, offering a scalable and efficient solution for running applications in a distributed environment.

#### Prerequisites
Ensure the following prerequisites are met before starting the Kubernetes cluster deployment:

#### Pre-provisioned Resources:

#### Access to pre-provisioned instances, including the Bastion Host, Control Plane, and Worker nodes.
SSH Key Pair:

#### Generate an SSH key pair for secure access to instances.
Ansible Installed:

#### Install Ansible on your local machine to orchestrate the deployment.
Deployment Steps
### Clone the Repository
Clone the repository containing the Ansible playbooks and configuration files:

```bash
git clone <repository-url>
cd <repository-directory>
```
#### Update Configuration
Edit the relevant configuration files, including _bastion_host.yaml, _controlplane.yaml, and _worker.yaml. Update variables such as SSH key paths, instance IPs, and any other configurations specific to your environment.

#### Run Ansible Playbooks
Execute the Ansible playbooks for each component:

### 1. Run the Master Playbook
Execute the masterplaybook.yaml to set up the Kubernetes cluster on the specified nodes. This playbook coordinates the installation of necessary components, such as Docker, kubelet, kubeadm, and kubectl, ensuring that the Control Plane and worker nodes are configured correctly.

```bash
ansible-playbook master_playbook.yaml
This playbook performs tasks like disabling swap, configuring the Kubernetes repository, installing required packages, initializing the Kubernetes Control Plane, setting permissions, and deploying the Flannel pod network.
```

### 2. SSH to Bastion and Run NGINX Command
Access the Bastion node using SSH and run an NGINX command as an example. This demonstrates the ability to securely connect to the Bastion node and execute commands.

```bash
ssh -i bastion_host_key ec2-user@$BASTION_IP
kubectl get nodes
Ensure that you replace <path-to-ssh-key> with the path to your SSH private key and <bastion-ip> with the actual IP address of the Bastion node.
```

### 3. Run Terraform Apply
Deploy additional worker nodes using Terraform. Make sure you have Terraform installed on your local machine and navigate to the Terraform directory before running the following command:

```bash
terraform apply --var worker_count=2
Adjust the worker_count variable according to the number of additional worker nodes you want to add to the Kubernetes cluster.
```

### 4. Run Manual Worker Playbook
Run the _worker.yaml playbook again to configure the newly added worker nodes with the required Kubernetes components.

```bash
ansible-playbook _worker.yaml
This playbook ensures consistency across all worker nodes, configuring them to join the existing Kubernetes cluster.
```

### 5. Access Bastion and Execute kubectl
SSH into the Bastion node and use kubectl to check the status of the Kubernetes nodes. This step confirms that the Kubernetes cluster is operational.

```bash
ssh -i bastion_host_key ec2-user@$BASTION_IP
kubectl get nodes
Verify that the Kubernetes nodes, including the newly added workers, are in the Ready state.
```

### 6. Destroy Infrastructure
If needed, you can destroy the entire infrastructure using Terraform. Navigate to the Terraform directory and run:

```bash
terraform destroy
```
This command cleans up all resources created by Terraform, effectively tearing down the Kubernetes cluster and associated infrastructure.

These detailed steps provide a clear and comprehensive guide for deploying, expanding, and managing a Kubernetes cluster using Ansible and Terraform. Adjust the commands and playbook paths based on your specific environment and configurations.
