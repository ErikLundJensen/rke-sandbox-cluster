#!/bin/bash -e

# Password for keygen must be set
# export PASSWORD=

# SSH keygen email
export email="erik@lund.ai"

echo "Setup ssh with passwordless login. Also add identity to ssh-agent. E.g."

# At bastion/jumpserver create ssh key and distribute to other servers
# TODO: be aware of special characters in password, it might crash the following command...
#eval home=~${USER};

mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/id_rsa -N $PASSWORD
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# TODO: note that ssh-copy-id asks for confirming "yes" and password
echo "Distribute public keys to other servers in cluster"
for server in  $(cat inventory.txt)
do
  echo Server: $server
  ssh-copy-id root@$server -f
#  scp ~/.ssh/id_rsa.pub root@$server:~/.ssh/id_rsa.pub
done

echo Public keys distributed