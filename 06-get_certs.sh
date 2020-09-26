#!/bin/bash
mkdir -p ca
ssh node1.devopslive.ru sudo cat /etc/kubernetes/ssl/kube-ca.pem > ca/kube-ca.pem
ssh node1.devopslive.ru sudo cat /etc/kubernetes/ssl/kube-ca-key.pem > ca/kube-ca-key.pem
chmod 400 ca/*
