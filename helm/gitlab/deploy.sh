#!/usr/bin/env bash
set -ex
helm repo add gitlab https://charts.gitlab.io/
helm repo update
#helm upgrade --install gitlab gitlab/gitlab \
#  --set global.hosts.domain=mytonic.com \
#  --set global.hosts.gitlab.name=gitlab.mytonic.com \
#  --set global.hosts.registry.name=registry.mytonic.com \
#  --set global.hosts.minio.name=minio.mytonic.com \
#  --set global.hosts.externalIP=192.168.10.11 \
#  --set certmanager-issuer.email=admin@mytonic.com

helm upgrade --install gitlab gitlab/gitlab \
  --set global.hosts.domain=mytonic.com \
  --set global.hosts.externalIP=192.168.10.11 \
  --set certmanager-issuer.email=admin@mytonic.com