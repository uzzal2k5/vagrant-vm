#!/usr/bin/env bash
set -ex
K8S_MASTER_IP="192.168.10.10"
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -t vagrant@"$K8S_MASTER_IP" sudo --user=vagrant  bash dashboard.sh
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -t vagrant@"$K8S_MASTER_IP" sudo --user=vagrant  bash helm-bootstrap.sh
#sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -t vagrant@"$K8S_MASTER_IP" sudo --user=vagrant  bash deploy-gitlab.sh