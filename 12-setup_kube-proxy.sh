#!/bin/bash

cfssl gencert \
  -ca="ca/kube-ca.pem" \
  -ca-key="ca/kube-ca-key.pem" \
  -config="cfssl/config.json" \
  -profile=kubernetes \
  vanilla/proxy/proxy-csr.json |
  cfssljson -bare pki/proxy

rm pki/proxy.csr

scp ca/kube-ca.pem pki/proxy* vanilla/proxy/* node3.devopslive.ru:~/

ssh node3.devopslive.ru sudo bash -s <<EOF
mkdir /etc/kubernetes/ssl/
mkdir -p /etc/kubernetes/config
ln -s -T /etc/kubernetes/config/kubelet.kubeconfig /etc/kubernetes/ssl/kubecfg-kube-node.yaml
cat proxy-key.pem > /etc/kubernetes/pki/proxy-key.pem
cat proxy.pem > /etc/kubernetes/pki/proxy.pem
cat kube-ca.pem > /etc/kubernetes/pki/kube-ca.pem
cat kube-proxy-config.yaml > /etc/kubernetes/config/kube-proxy-config.yaml
cat proxy.kubeconfig > /etc/kubernetes/config/proxy.kubeconfig
cat kube-proxy.service > /etc/systemd/system/kube-proxy.service
rm proxy* kube-ca.pem kube-proxy*
systemctl daemon-reload
systemctl restart kube-proxy
EOF
