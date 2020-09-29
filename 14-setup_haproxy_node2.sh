#!/bin/bash

scp pki/haproxy* vanilla/haproxy/haproxy.cfg node2.devopslive.ru:~/

ssh node2.devopslive.ru sudo bash -s <<EOF
mkdir -p /etc/kubernetes/pki
cat haproxy-key.pem haproxy.pem > /etc/kubernetes/pki/healthcheck.pem
rm haproxy-key.pem haproxy.pem
mv haproxy.cfg /etc/haproxy/haproxy.cfg
docker stop kube-apiserver && docker rm kube-apiserver
systemctl restart haproxy
EOF
