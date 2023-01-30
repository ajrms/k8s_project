#!/usr/bin/env bash

# init kubernetes for kubeadm
sudo kubeadm config images pull --cri-socket unix:///run/cri-dockerd.sock

sudo kubeadm init --token 123456.1234567890123456 \
            --token-ttl 0 \
            --pod-network-cidr=10.10.0.0/16 \
            --apiserver-advertise-address=192.168.0.100 \
            --cri-socket /var/run/cri-dockerd.sock \
            --ignore-preflight-errors=ALL

            # --apiserver-advertise-address=192.168.50.100 \
# master node config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install calico
curl https://projectcalico.docs.tigera.io/manifests/calico.yaml -O
# sed -i -e 's?192.168.0.0/16?10.10.0.0/16?g' calico.yaml
sed -i -e 's?192.168.0.0/24?10.10.0.0/16?g' calico.yaml

kubectl apply -f calico.yaml

# add --node-ip
# echo Environment="KUBELET_EXTRA_ARGS=--node-ip=192.168.50.100" >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
echo Environment="KUBELET_EXTRA_ARGS=--node-ip=192.168.0.100" >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl daemon-reload
systemctl restart kubelet