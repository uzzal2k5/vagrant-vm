#!/usr/bin/env bash
set -ex
K8S_MASTER_IP="192.168.10.10"
echo "Configuring Kubernetes Node"
apt-get install -y sshpass
sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@"$K8S_MASTER_IP":/etc/kubeadm_join_cmd.sh .
sh ./kubeadm_join_cmd.sh