# Rancher RKE for DigitalOcean

## RKE relevant links

Ranger RKE release note with supported Kubernetes versions.  
We choose v1.16.3-rancher1-1  
https://github.com/rancher/rke/releases/tag/v1.0.0

Validated Docker version to install:  
https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.16.md

The current list is 1.13.1, 17.03, 17.06, 17.09, 18.06, 18.09  
We choose Docker version ```18.09.11```


## SSH Server Configuration
Your SSH server system-wide configuration file, located at /etc/ssh/sshd_config, must include this line that allows TCP forwarding:  
```AllowTcpForwarding yes```

## Order of execution

role-bastian/00-ssh-root-setup.sh
role-bastian/01-bastian-setup.sh
for each node in inventory:
  role-nodes/02-install-prereq.sh
role-bastian/03-ssh-setup.sh
role-cluster/

# Firewalls
TODO: This is currently not part of this setup