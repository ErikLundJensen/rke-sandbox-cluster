#!/bin/bash

# Requires login to argo server before execution (or setup of argo config file).
# argocd login argo-dev.digitalocean.local --insecure --username admin --grpc-web --password TODO

echo REMEMBER TO LOG IN TO ARGO-CD BEFORE RUNNING THIS SCRIPT

mkdir -p tmp

echo -n `pwgen -s 16 -1` > ./tmp/grafana-password.plain
sed -e s/{{GENPASSWORD}}/`cat ./tmp/grafana-password.plain`/g < manifest/prometheus-operator-argo.tpl > ./tmp/prometheus-operator-argo.yaml

# Using --upsert in case of application already exists.

argocd app create prometheus-operator -f ./tmp/prometheus-operator-argo.yaml --upsert




