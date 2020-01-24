#!/bin/bash -e

mkdir -p tmp

# Grafana
export KEY_FILE=./tmp/prometheus-operator-grafana-keyfile.pem
export CERT_FILE=./tmp/prometheus-operator-grafana-keyfile.cert
export HOST=grafana.apps.rke1.test.2108.dk
export CERT_NAME=prometheus-operator-grafana-ingress-secret
export NAMESPACE=monitoring

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n ${NAMESPACE}

# Kibana
export KEY_FILE=./tmp/kibana-keyfile.pem
export CERT_FILE=./tmp/kibana-keyfile.cert
export HOST=kibana.apps.rke1.test.2108.dk
export CERT_NAME=kibana-ingress-secret
export NAMESPACE=logging

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n ${NAMESPACE}

export KEY_FILE=./tmp/container-nexus-keyfile.pem
export CERT_FILE=./tmp/container-nexus-keyfile.cert
export HOST=container-nexus.apps.rke1.test.2108.dk
export CERT_NAME=container-nexus-ingress-secret
export NAMESPACE=default

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n ${NAMESPACE}

export KEY_FILE=./tmp/nexus-keyfile.pem
export CERT_FILE=./tmp/nexus-keyfile.cert
export HOST=nexus.apps.rke1.test.2108.dk
export CERT_NAME=nexus-ingress-secret
export NAMESPACE=default

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n ${NAMESPACE}

export KEY_FILE=./tmp/driverlicense-keyfile.pem
export CERT_FILE=./tmp/driverlicense-keyfile.cert
export HOST=driverlicense-dev.apps.rke1.test.2108.dk
export CERT_NAME=driverlicense-ingress-secret
export NAMESPACE=dev

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n ${NAMESPACE}
