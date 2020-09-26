# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "devopslive"
NODE_COUNT = 3

Vagrant.configure("2") do |config|
  (1..NODE_COUNT).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.box = BOX_IMAGE
      node.vm.provider "virtualbox" do |v|
        v.memory = 1536
        v.cpus = 2
      end
      node.vm.hostname = "node#{i}.devopslive.ru"
      node.vm.network :private_network, ip: "10.0.0.#{i + 10}"
      node.vm.provision :hosts, sync_hosts: true
    end
  end
end
