cluster_name: "demo18"
nodes:
- address: 167.71.49.188
  port: "22"
  internal_address: ""
  role:
  - controlplane
  - etcd
  user: rkeadmin
  docker_socket: /var/run/docker.sock
  ssh_key_path: ~/.ssh/id_rsa
  ssh_agent_auth: true
  labels: {}
  taints: []
- address: 167.71.53.196
  port: "22"
  role:
  - worker
  user: rkeadmin
  docker_socket: /var/run/docker.sock
  ssh_key_path: ~/.ssh/id_rsa
  ssh_agent_auth: true
- address: 46.101.164.217
  port: "22"
  role:
    - worker
  user: rkeadmin
  docker_socket: /var/run/docker.sock
  ssh_key_path: ~/.ssh/id_rsa
  ssh_agent_auth: true
services:
  kube-api:
    service_cluster_ip_range: 10.43.0.0/16
    pod_security_policy: false
    always_pull_images: false
  kube-controller:
    cluster_cidr: 10.42.0.0/16
    service_cluster_ip_range: 10.43.0.0/16
  kubelet:
    cluster_domain: cluster.local
    cluster_dns_server: 10.43.0.10
    fail_swap_on: false
    generate_serving_certificate: false
network:
  plugin: canal
authentication:
  strategy: x509
user: rkeadmin
ssh_key_path: ~/.ssh/id_rsa
ssh_cert_path: ""
ssh_agent_auth: true
authorization:
  mode: rbac
ignore_docker_version: false
private_registries:
  - url: quay.io
    user: "a329212+rke"
    password: {{GEN_QUAY_PASSWORD}}
dns:
  provider: coredns
  upstreamNameservers:
  - "8.8.8.8"
  - "8.8.4.4"
# All add-on manifests MUST specify a namespace
# Weave Scope downloaded from https://www.weave.works/docs/scope/latest/installing/#k8s
addons: ""
addons_include:
  - addons/namespaces.yaml

