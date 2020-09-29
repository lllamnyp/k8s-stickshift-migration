# RKE -> vanilla migration

## DevOps live 2020 demo

### Requirements

- Vagrant
  - `vagrant plugin install vagrant-hosts`

- Hosts file:

``` ==> /etc/hosts <==
10.0.0.11 node1.devopslive.ru
10.0.0.12 node2.devopslive.ru
10.0.0.13 node3.devopslive.ru
```

- Haproxy

- Docker

- SSH config

```
Host node*.devopslive.ru
# =============> PATH TO REPO ROOT HERE .................................. <=============
  IdentityFile /home/lllamnyp/Cloud/dev/devopsconf/k8s-stickshift-migration/devopslive_rsa
  User vagrant
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
```
