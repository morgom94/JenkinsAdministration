#! /bin/bash
#
sudo swapoff -a
sudo systemctl stop kubelet.service
sudo kubeadm reset -f
kubeadm init
#
sudo cp  /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl taint nodes --all node-role.kubernetes.io/master-
#
kubectl apply -f mysql-pv.yaml
kubectl apply -f mysql-deployment3.yaml
#
echo MySQL deployed
#
kubectl apply -f drupal-pv.yaml
kubectl apply -f drupal-deployment.yaml
#
echo Drupal deployed
#
