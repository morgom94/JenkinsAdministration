# JenkinsAdministration

# Docker
########################
echo "Installing Docker"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update

sudo apt-get -y install docker-ce

sudo systemctl enable docker

sudo usermod -aG docker ${USER}


#Drupal
########################

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -


cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

sudo apt-get install -y kubelet kubeadm kubectl

mkdir /mnt/data

sudo kubeadm init --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl get pods --all-namespaces --watch

kubectl apply -f mysql-pv.yaml

kubectl apply -f mysql-deployment.yaml

kubectl get pods --all-namespaces --watch

kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -ppassword

kubectl apply -f drupal-pv.yaml

kubectl apply -f drupal-deployment.yaml

kubectl get svc    cluster ip & port

curl 10.100.84.85:80
