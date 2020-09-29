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

sudo bash -s <<EOF
mkdir -p /etc/kubernetes/pki
cat pki/haproxy-key.pem pki/haproxy.pem > /etc/kubernetes/pki/healthcheck.pem
cp vanilla/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg
systemctl restart haproxy
EOF

sed -i 's|server: ".*"|server: "https://127.0.0.1:6443"|' rke/kube_config_cluster.yml
