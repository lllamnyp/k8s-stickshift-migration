#!/bin/bash

kubectl apply -f vanilla/haproxy/rbac.yaml

cfssl gencert \
  -ca="ca/kube-ca.pem" \
  -ca-key="ca/kube-ca-key.pem" \
  -config="cfssl/config.json" \
  -profile=kubernetes \
  vanilla/haproxy/haproxy-csr.json |
  cfssljson -bare pki/haproxy

rm pki/haproxy.csr

scp pki/haproxy* node3.devopslive.ru:~/

ssh node3.devopslive.ru sudo bash -s <<EOF
mkdir -p /etc/kubernetes/pki
cat haproxy-key.pem haproxy.pem > /etc/kubernetes/pki/healthcheck.pem
EOF
