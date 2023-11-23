#!/bin/bash

# Disable swap and zram
sudo swapoff -a 
sudo zramctl --reset /dev/zram0

# Add kubernetes repository
if ! test -f /etc/yum.repos.d/kubernetes.repo ; then
    sudo sh -c 'cat > /etc/yum.repos.d/kubernetes.repo <<EOL
[kubernetes]
baseurl = https://pkgs.k8s.io/core:/stable:/v1.26/rpm/
exclude = kubelet kubeadm kubectl cri-tools kubernetes-cni
gpgkey = https://pkgs.k8s.io/core:/stable:/v1.26/rpm/repodata/repomd.xml.key
name = kubernetes yum repo
repo_gpgcheck = 1
EOL'
fi

# Install required packages
sudo yum -y install docker kubelet kubeadm kubectl --disableexcludes=kubernetes

# Enable and start services
sudo systemctl enable docker
sudo systemctl restart docker
sudo systemctl enable kubelet
sudo systemctl restart kubelet

# Intialize kubernetes if no configuration file exists
if ! test -f /etc/kubernetes/kubelet.conf; then
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU,Mem
fi

# Setup kubeconfig
sudo chmod 0644 /etc/kubernetes/admin.conf
mkdir -p ~/.kube
cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

# Install Flannel pod network if no networking pod exists
if ! kubectl get pods --all-namespaces | grep kube-flannel; then
    kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
fi

# Generate join command
kubeadm token create --print-join-command > join-command.sh
