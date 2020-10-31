#!/bin/bash

sudo yum update -q -y && \ 
sudo yum upgrade -q -y && \ 
sudo yum install git wget -q -y && \
sudo yum install bind-utils  -q -y 

mkdir /home/vault/scripts

########### Add script for ==> bash_completion

cat >/home/vault/scripts/after_install_k8s.sh <<-"EOF"
#!/bin/bash

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo yum install bash-completion -y

source /usr/share/bash-completion/bash_completion

echo 'source <(kubectl completion bash)' >>~/.bashrc

echo 'alias k=kubectl' >>~/.bashrc

echo 'complete -F __start_kubectl k' >>~/.bashrc

exec bash

EOF

sudo chmod +x /home/vault/scripts/after_install_k8s.sh


cat >/home/vault/scripts/helm_install.sh <<-"EOF"
#!/bin/bash

############### Get Helm

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

helm repo add stable https://charts.helm.sh/stable

EOF

sudo chmod +x /home/vault/scripts/helm_install.sh


cat >/home/vault/scripts/cert_manager_install.sh <<-"EOF"
#!/bin/bash

##############Install cert-manager

kubectl create namespace cert-manager

helm repo add jetstack https://charts.jetstack.io

helm repo update

# Helm v3+
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.0.3 \
  --set installCRDs=true

EOF

sudo chmod +x /home/vault/scripts/cert_manager_install.sh
