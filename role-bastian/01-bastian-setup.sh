#!/bin/bash -e

# Script for setting up Bastian server with tools for management of RKE

apt-get update

echo "Install git and utilities jq and yq"
apt-get install git jq pwgen apache2-utils -y

add-apt-repository ppa:rmescandon/yq
apt update
apt install yq -y

echo kubectl - Latest stable version:
curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt

# Install specific version of kubectl. The tool is backwards compatible with previous version.
# Thereby version 1.17 is compatible with Kubernetes version 1.16, however, version 1.18 can't be used until RKE cluster is upgraded.

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/amd64/kubectl

mv kubectl /usr/local/bin
chmod 755 /usr/local/bin/kubectl

# Get Helm cli
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 744 get_helm.sh
./get_helm.sh

# Get Argo-cd cli
VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
curl -LO -sSL https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64
mv argocd-linux-amd64 /usr/local/bin/argocd
chmod +x /usr/local/bin/argocd

# Get Kompose utility - a tool for converting Docker Compose to Kubernetes yaml
curl -L https://github.com/kubernetes/kompose/releases/download/v1.19.0/kompose-linux-amd64 -o kompose
chmod 755 kompose
mv ./kompose /usr/local/bin/kompose




