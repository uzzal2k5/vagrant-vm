#!/usr/bin/env bash
# Preconfigure and install require packages
set -ex
DOCKER_VERSION="19.03"
K8S_MASTER="k8s-master"
K8S_MASTER_IP="192.168.10.10"
    # reason for not using docker provision is that it always installs latest version of the docker, but kubeadm requires 17.03 or older
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common socat
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
    apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep "${DOCKER_VERSION}" | head -1 | awk '{print $3}')

    # run docker commands as vagrant user (sudo not required)
    usermod -aG docker vagrant
    # Setup daemon.
    cat <<EOF >/etc/docker/daemon.json
    {
      "exec-opts": ["native.cgroupdriver=systemd"],
      "log-driver": "json-file",
      "log-opts": {
        "max-size": "100m"
      },
      "storage-driver": "overlay2"
    }
EOF
    mkdir -p /etc/systemd/system/docker.service.d
    # Restart docker.
    systemctl daemon-reload
    systemctl restart docker
    # install kubeadm
    apt-get install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
    deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
    apt-get update
    apt-get install -y kubelet kubeadm kubectl
    apt-mark hold kubelet kubeadm kubectl

    # kubelet requires swap off
    swapoff -a

    # keep swap off after reboot
    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

    # Open Ports
    sudo ufw disable
    #sudo ufw allow 6443
    #sudo ufw allow 10250
    # Enable kubelet
    sudo systemctl enable kubelet
    sudo systemctl restart kubelet
    sudo cat << EOF >>/etc/hosts
192.168.10.10 k8s-master
192.168.10.11 k8s-node-1
192.168.10.12 k8s-node-2
EOF