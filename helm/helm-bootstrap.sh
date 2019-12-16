#!/usr/bin/env bash
set -ex
HELM_VERSION=2.16.1
cd /home/vagrant/
wget https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz
tar -xzvf  helm-v$HELM_VERSION-linux-amd64.tar.gz 2>/dev/null
cd linux-amd64 && \
  sudo  mv helm /usr/local/bin/helm

#cat <<EOF > rbac-tiller.yaml
#apiVersion: v1
#kind: ServiceAccount
#metadata:
#  name: tiller
#  namespace: kube-system
#---
#kind: ClusterRoleBinding
#apiVersion: rbac.authorization.k8s.io/v1
#metadata:
#  name: tiller-clusterrolebinding
#subjects:
#- kind: ServiceAccount
#  name: tiller
#  namespace: kube-system
#roleRef:
#  kind: ClusterRole
#  name: cluster-admin
#EOF

kubectl -n kube-system create serviceaccount tiller

kubectl create clusterrolebinding tiller \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:tiller

helm init --service-account tiller

sleep 30
# Test Helm
helm version --short
helm ls --debug
kubectl get pods -n kube-system
