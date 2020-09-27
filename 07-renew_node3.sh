#!/bin/bash
vagrant destroy node3 -f
sleep 6
kubectl delete node node3.devopslive.ru
vagrant up node3

# TODO: Ensure correct provisioning of VM
ssh node3.devopslive.ru sudo bash -s <<EOF
add-apt-repository ppa:vbernat/haproxy-2.2 -y
apt install -y haproxy
apt install -y containerd conntrack
systemctl stop haproxy
systemctl disable haproxy
rm /etc/rsyslog.d/49-haproxy.conf
rm /etc/haproxy/haproxy.cfg
EOF
