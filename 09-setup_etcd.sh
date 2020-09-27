#!/bin/bash

bin/etcdctl endpoint health

cfssl gencert \
  -ca="ca/kube-ca.pem" \
  -ca-key="ca/kube-ca-key.pem" \
  -config="cfssl/config.json" \
  -profile=kubernetes \
  vanilla/etcd/etcd-client-csr.json |
  cfssljson -bare pki/etcd-client
cfssl gencert \
  -ca="ca/kube-ca.pem" \
  -ca-key="ca/kube-ca-key.pem" \
  -config="cfssl/config.json" \
  -profile=kubernetes \
  vanilla/etcd/etcd-peer-csr.json |
  cfssljson -bare pki/etcd-peer
cfssl gencert \
  -ca="ca/kube-ca.pem" \
  -ca-key="ca/kube-ca-key.pem" \
  -config="cfssl/config.json" \
  -profile=kubernetes \
  vanilla/etcd/etcd-server-csr.json |
  cfssljson -bare pki/etcd-server

rm pki/*.csr

old_id=$(bin/etcdctl member list | grep node3 | cut -f1 -d,)

bin/etcdctl member remove $old_id

bin/etcdctl member add etcd-node3.devopslive.ru --peer-urls="https://node3.devopslive.ru:2380"

scp ca/kube-ca.pem pki/etcd* vanilla/etcd/etcd.service node3.devopslive.ru:~/

ssh node3.devopslive.ru sudo bash -s <<EOF
mkdir -p /etc/kubernetes/pki
cat etcd-peer-key.pem > /etc/kubernetes/pki/etcd-peer-key.pem
cat etcd-peer.pem > /etc/kubernetes/pki/etcd-peer.pem
cat etcd-client-key.pem > /etc/kubernetes/pki/etcd-client-key.pem
cat etcd-client-key.pem > /etc/kubernetes/pki/etcd-client-key.pem
cat etcd-server.pem > /etc/kubernetes/pki/etcd-server.pem
cat etcd-server-key.pem > /etc/kubernetes/pki/etcd-server-key.pem
cat etcd.service > /etc/systemd/system/etcd.service
cat kube-ca.pem > /etc/kubernetes/pki/kube-ca.pem
rm etcd* kube-ca.pem
rm -rf /var/lib/etcd
systemctl daemon-reload
systemctl enable etcd
systemctl restart etcd
EOF

sleep 3

bin/etcdctl endpoint health
