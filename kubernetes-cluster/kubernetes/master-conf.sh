#!/usr/bin/env bash
set -ex
POD_NETWORK="10.244.0.0/16"
K8S_MASTER_IP="192.168.10.10"
echo "Configuring Kubernetes Master"

    # install k8s master
    HOST_NAME=$(hostname -s)
    kubeadm init --apiserver-advertise-address=$K8S_MASTER_IP --apiserver-cert-extra-sans=$K8S_MASTER_IP  --node-name $HOST_NAME --pod-network-cidr=$POD_NETWORK

    #Copying credentials to regular user - vagrant
    sudo --user=vagrant mkdir -p /home/vagrant/.kube
    cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
    chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config

    # install Flannel pod network addon
    export KUBECONFIG=/etc/kubernetes/admin.conf
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
    kubeadm token create --print-join-command >> /etc/kubeadm_join_cmd.sh
    chmod +x /etc/kubeadm_join_cmd.sh
    # Modify kube-apiserver
    #sed -i.bak  -e "26i\ \ \ \ \- --runtime-config=apps/v1beta1=true,extensions/v1beta1/deployments=true" /etc/kubernetes/manifests/kube-apiserver.yaml

    # required for setting up password less ssh between guest VMs
    sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
    sudo service sshd restart