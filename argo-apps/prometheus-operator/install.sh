#!/bin/bash

# Requires login to argo server before execution (or setup of argo config file).
# argocd login argo-dev.digitalocean.local --insecure --username admin ---grpc-web -password TODO

echo -n `pwgen -s 16 -1` > ./tmp/grafana-password.plain
sed -e s/{{GENPASSWORD}}/`cat ./tmp/grafana-password.plain`/g < prometheus-operator.tpl > ./tmp/prometheus-operator.yaml

argocd app create prometheus-operator -f ./tmp/prometheus-operator.yaml




