#!/bin/bash
vagrant destroy node3 -f
sleep 6
kubectl delete node node3.devopslive.ru --server=https://node1.devopslive.ru:6443
vagrant up node3
