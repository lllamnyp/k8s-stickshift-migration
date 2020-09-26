if [[ ! -f bin/rke ]]
then
  wget "https://github.com/rancher/rke/releases/download/v0.3.1/rke_linux-amd64" -O bin/rke;
fi
chmod 755 bin/rke

mkdir -p basebox/pre/bin

cd basebox/pre/bin

if [[ ! -f kubelet ]] && [[ ! -f kube-controller-manager ]] && [[ ! -f kube-scheduler ]] && [[ ! -f kube-apiserver ]] && [[ ! -f kube-proxy ]]
then
  wget https://dl.k8s.io/v1.15.12/kubernetes-server-linux-amd64.tar.gz -O /tmp/serverbin.tar.gz
  tar -xf /tmp/serverbin.tar.gz
  rm kubernetes/server/bin/*.tar kubernetes/server/bin/*.docker_tag kubernetes/server/bin/{kubeadm,kubectl}
  mv kubernetes/server/bin/kube* ./
  rm -rf kubernetes
  rm /tmp/serverbin.tar.gz
fi

if [[ ! -f etcd ]] && [[ ! -f etcdctl ]]
then
  wget https://storage.googleapis.com/etcd/v3.3.25/etcd-v3.3.25-linux-amd64.tar.gz -O /tmp/etcd.tar.gz
  tar -xf /tmp/etcd.tar.gz
  mv etcd-v3.3.25-linux-amd64/etcd* ./
  rm -rf etcd-v3.3.25-linux-amd64
  rm /tmp/etcd.tar.gz
fi

if [[ ! -f ../../../bin/etcdctl ]]
then
  cp etcdctl ../../../bin/etcdctl
fi

cd ..

# Preload tarball of rancher images
if [[ ! -f ./images-v1.15.tar ]]
then
  while read line
  do
    docker pull $line
  done < ./images-v1.15
  cat ./images-v1.15 | xargs docker save > ./images-v1.15.tar
fi
