#!/bin/bash

# As rkeadmin execute the following commands

curl -LO https://github.com/rancher/rke/releases/download/v1.0.0/rke_linux-amd64

mkdir -p bin
mv rke_linux-amd64 bin/rke
chmod +x bin/rke

bin/rke --version

