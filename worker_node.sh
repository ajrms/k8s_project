#!/usr/bin/env bash

# worker node config
# kubeadm join 192.168.50.100:6443 \
kubeadm join 192.168.0.100:6443 \
        --token 123456.1234567890123456 \
        --discovery-token-unsafe-skip-ca-verification \
        --cri-socket unix:///run/cri-dockerd.sock \
        --ignore-preflight-errors=ALL