export ETCDCTL_API=3
export ETCDCTL_CACERT=./ca/kube-ca.pem
export ETCDCTL_CERT=./pki/etcd-client.pem
export ETCDCTL_KEY=./pki/etcd-client-key.pem
export ETCDCTL_ENDPOINTS=https://10.0.0.11:2379,https://10.0.0.12:2379,https://10.0.0.13:2379
