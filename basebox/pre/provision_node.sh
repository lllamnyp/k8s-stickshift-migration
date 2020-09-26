#!/usr/bin/env bash

apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    ca-certificates \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

swapoff --all

add-apt-repository ppa:vbernat/haproxy-2.2 -y

# Remove swap mountpoint from fstab
sed -i /swap/d /etc/fstab

mount -a

apt-get update
apt-get install -y docker-ce=18.06.3~ce~3-0~ubuntu haproxy
systemctl stop haproxy
systemctl disable haproxy
rm /etc/rsyslog.d/49-haproxy.conf
rm /etc/haproxy/haproxy.cfg

apt-mark hold docker-ce

usermod -aG docker vagrant

mkdir -p /home/vagrant/.ssh

cat /vagrant/devopslive_rsa.pub >> /home/vagrant/.ssh/authorized_keys

chown -R vagrant:vagrant /home/vagrant/.ssh

chmod 600 /home/vagrant/.ssh/authorized_keys

while read line
do
  docker pull $line
done < /vagrant/images-v1.15

cp /vagrant/bin/* /usr/local/bin/

