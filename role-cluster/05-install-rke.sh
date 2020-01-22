#!/bin/bash

# Create secret for Nexus
echo -n `pwgen -s 16 -1` > ./nexus-password.plain
htpasswd -cb auth nexus `cat ./nexus-password.plain`
sed -e s/{{GENPASSWORD}}/`cat ./nexus-password.plain`/g < cluster.tpl > .cluster.yaml

# Have to setup agent before running ssh-add
eval "$(ssh-agent -s)"
ssh-add ~rkeadmin/.ssh/id_rsa

rke up

# Setup kube config
mkdir ~rkeadmin/.kube
mv  kube_config_cluster.yml ~rkeadmin/.kube/config

echo Backup of file cluster.rkestate

echo Done
