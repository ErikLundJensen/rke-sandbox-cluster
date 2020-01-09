#!/bin/bash -e

export KEY_FILE=./tmp/prometheus-operator-keyfile.pem
export CERT_FILE=./tmp/prometheus-operator-keyfile.cert
export HOST=prometheus.digitalocean.local
export CERT_NAME=prometheus-operator-ingress-secret
export NAMESPACE=monitoring

mkdir -p tmp

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n ${NAMESPACE}

export KEY_FILE=./tmp/prometheus-operator-grafana-keyfile.pem
export CERT_FILE=./tmp/prometheus-operator-grafana-keyfile.cert
export HOST=grafana.digitalocean.local
export CERT_NAME=prometheus-operator-grafana-ingress-secret

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n ${NAMESPACE}
