#!/bin/sh

KUBERNETES_VERSION="$1"

set -e

K8S_DIR=$(dirname "$0")

kubeadm init --kubernetes-version "${KUBERNETES_VERSION}" --pod-network-cidr=192.168.0.0/16 --skip-token-print

mkdir -p "$HOME"/.kube
sudo cp -f /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u):$(id -g)" "$HOME"/.kube/config

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=192.168.0.0/16"

kubectl taint nodes --all node-role.kubernetes.io/master-

kubeadm token create --print-join-command > "${K8S_DIR}/join-cluster.sh"
