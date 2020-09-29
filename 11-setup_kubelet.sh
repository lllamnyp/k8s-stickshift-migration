#!/bin/bash

cfssl gencert \
  -ca="ca/kube-ca.pem" \
  -ca-key="ca/kube-ca-key.pem" \
  -config="cfssl/config.json" \
  -profile=kubernetes \
  vanilla/kubelet/kubelet-csr.json |
  cfssljson -bare pki/kubelet

rm pki/kubelet.csr

scp ca/kube-ca.pem pki/kubelet* vanilla/kubelet/* node3.devopslive.ru:~/

ssh node3.devopslive.ru sudo bash -s <<EOF
mkdir -p /etc/kubernetes/config
cat kube-ca.pem > /etc/kubernetes/pki/kube-ca.pem
cat kubelet-key.pem > /etc/kubernetes/pki/kubelet-key.pem
cat kubelet.pem > /etc/kubernetes/pki/kubelet.pem
cat kubelet-config.yaml > /etc/kubernetes/config/kubelet-config.yaml
cat kubelet.kubeconfig > /etc/kubernetes/config/kubelet.kubeconfig
cat kubelet.service > /etc/systemd/system/kubelet.service
rm kubelet* kube-ca.pem
systemctl daemon-reload
systemctl restart kubelet
EOF

sleep 7
kubectl label node node3.devopslive.ru node-role.kubernetes.io/worker=true
