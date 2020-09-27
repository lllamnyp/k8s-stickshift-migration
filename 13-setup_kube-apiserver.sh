#!/bin/bash

cfssl gencert \
  -ca="ca/kube-ca.pem" \
  -ca-key="ca/kube-ca-key.pem" \
  -config="cfssl/config.json" \
  -profile=kubernetes \
  vanilla/apiserver/apiserver-csr.json |
  cfssljson -bare pki/apiserver

rm pki/apiserver.csr

scp ca/sa.pem pki/apiserver* vanilla/apiserver/* node3.devopslive.ru:~/

ssh node3.devopslive.ru sudo bash -s <<EOF
cat apiserver-key.pem > /etc/kubernetes/pki/apiserver-key.pem
cat apiserver.pem > /etc/kubernetes/pki/apiserver.pem
cat sa.pem > /etc/kubernetes/pki/sa.pem
cat kube-apiserver.service > /etc/systemd/system/kube-apiserver.service
rm apiserver* sa.pem kube-apiserver*
systemctl daemon-reload
systemctl restart kube-apiserver
EOF

kubectl label node node3.devopslive.ru node-role.kubernetes.io/controlplane=true
