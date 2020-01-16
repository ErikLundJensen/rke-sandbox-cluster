#!/bin/bash

# Have to setup agent before running ssh-add

eval "$(ssh-agent -s)"
ssh-add ~rkeadmin/.ssh/id_rsa

rke up

# Setup kube config
mkdir ~rkeadmin/.kube
mv  kube_config_cluster.yml ~rkeadmin/.kube/config

echo Backup of file cluster.rkestate

echo Done
