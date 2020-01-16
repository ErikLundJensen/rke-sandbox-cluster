#!/bin/bash -e

# Run this script for each server in inventory

# Pre-req for RKE is described here:
# https://rancher.com/docs/rke/latest/en/os/

# This script does not contain error handling as that will be done when converted to Ansible playbook
# Please note, set PASSWORD before running this script

# TODO: verify SSH version.
# In order to SSH into each node, OpenSSH 7.0+ must be installed on each node.

# Validated docker version matching Kubernetes 1.16 and RKE 1.0.0
export DOCKER_VERSION=18.09.9

# Read password from vault
#export PASSWORD=

for module in br_netfilter ip6_udp_tunnel ip_set ip_set_hash_ip ip_set_hash_net iptable_filter iptable_nat iptable_mangle iptable_raw nf_conntrack_netlink nf_conntrack nf_conntrack_ipv4   nf_defrag_ipv4 nf_nat nf_nat_ipv4 nf_nat_masquerade_ipv4 nfnetlink udp_tunnel veth vxlan x_tables xt_addrtype xt_conntrack xt_comment xt_mark xt_multiport xt_nat xt_recent xt_set  xt_statistic xt_tcpudp;
do
  if ! lsmod | grep -q $module; then
    echo "module $module is not present. Adding module.";
    modprobe $module
  fi;
done

echo "Verify iptables config. Must have a value of 1 (todo: missing validation)"
sysctl -n net.bridge.bridge-nf-call-iptables

echo "****** Docker setup ******* "

# Add Docker repository
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update

echo Check available docker-ce version
apt-cache madison docker-ce | grep $DOCKER_VERSION

echo "Use docker-ce package name and version from above greb (here it is currently hardcoded)"
apt-get install -y docker-ce=5:18.09.9~3-0~ubuntu-$(lsb_release -cs)  docker-ce-cli=5:18.09.9~3-0~ubuntu-$(lsb_release -cs) containerd.io

apt-mark hold docker-ce docker-ce-cli

# TODO: lock docker-ce version

# Verify Docker is installed correctly, running as root
docker run hello-world

echo "****** Docker installed ******* "

# TODO: add docker options like storage. See also
#  https://docs.docker.com/config/daemon/systemd/

# Be aware of already existing group and user in Ansible...

groupadd -f docker
useradd -m -s $(which bash) -G sudo rkeadmin
usermod -aG docker rkeadmin
echo -e "$PASSWORD\n$PASSWORD" | passwd rkeadmin

echo Start docker at boot
systemctl enable docker

# Verify Docker is installed correctly, running as rkeadmin
sudo -u rkeadmin docker run hello-world

# Disable swap
swapoff -a
echo vm.swappiness=0 | tee -a /etc/sysctl.conf


# Create filestorage for simulating volumes
# TODO this should probably not be done at on-premise hosts. Might need to mount instead.
mkdir -p /filestorage
mkdir -p /db

echo Reboot node. TODO. ask before reboot..
# reboot system