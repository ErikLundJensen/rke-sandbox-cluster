#!/bin/bash -e

# SSH keygen email
export email="erik@lund.ai"

echo "Setup ssh with passwordless login. Also add identity to ssh-agent. E.g."

# At bastion/jumpserver create ssh key and distribute to other servers

# Create rkeadmin
useradd -m -s $(which bash) -G sudo rkeadmin
echo -e "$PASSWORD\n$PASSWORD" | passwd rkeadmin

mkdir -p ~rkeadmin/.ssh
ssh-keygen -t rsa -b 4096 -C "$email" -f ~rkeadmin/.ssh/id_rsa -N $PASSWORD
eval "$(ssh-agent -s)"
ssh-add ~rkeadmin/.ssh/id_rsa
chown -R rkeadmin ~rkeadmin/.ssh
chgrp -R rkeadmin ~rkeadmin/.ssh

# Setup bash completion for kubectl
echo 'source <(kubectl completion bash)' >>~rkeadmin/.bashrc
echo 'alias k=kubectl' >>~rkeadmin/.bashrc
echo 'complete -F __start_kubectl k' >>~rkeadmin/.bashrc

# Setup bash completion for helm
echo 'source <(helm completion bash)' >>~rkeadmin/.bashrc


# TODO: note that ssh-copy-id asks for confirming "yes" and password
echo "Distribute public keys to other servers in cluster"
for server in  $(cat inventory.txt)
do
  echo Server: $server
  # TODO: run as rkeadmin!!
  ssh-copy-id rkeadmin@$server -f
  eval "$(ssh-agent -s)"
  ssh-add
  scp ~rkeadmin/.ssh/id_rsa.pub rkeadmin@$server:~rkeadmin/.ssh/id_rsa.pub
  ssh root@$server chown -R rkeadmin ~rkeadmin/.ssh
  ssh root@$server chgrp -R rkeadmin ~rkeadmin/.ssh
done

echo Public keys distributed
