#!/bin/bash

scp pki/haproxy* vanilla/haproxy/haproxy.cfg node1.devopslive.ru:~/

ssh node1.devopslive.ru sudo bash -s <<EOF
mkdir -p /etc/kubernetes/pki
cat haproxy-key.pem haproxy.pem > /etc/kubernetes/pki/healthcheck.pem
rm haproxy-key.pem haproxy.pem
mv haproxy.cfg /etc/haproxy/haproxy.cfg
docker stop kube-apiserver && docker rm kube-apiserver
systemctl restart haproxy
EOF
