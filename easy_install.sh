#!/bin/bash
####INSTALANDO SNAPS - MICROK8S HELM
#sudo snap install microk8s --classic    						#ONLINE INSTALLATION
sudo ufw default allow routed
sudo iptables -P FORWARD ACCEPT
PROGRAMA=$(type microk8s.status 2>/dev/null | wc -l)
if [ $PROGRAMA -eq 0 ]
	then		
		echo -e "${LIGHT_BLUE}Instalando microk8s${NC}"
		sudo snap install microk8s --classic #--channel=1.14/stable
	else
	echo -e "${LIGHT_BLUE}Microk8s já está instalado${NC}"
fi

microk8s.status 

###CONFIGURANDO O ALIAS
sudo snap alias microk8s.kubectl kubectl
microk8s.enable dns 
sleep 30
sudo ufw allow in on cbr0 && sudo ufw allow out on cbr0

### BAIXANDO E CONFIGURANDO ISTIO
cd ~
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.2.2 sh -
cd istio*
cp tools/istioctl.bash ~
export PATH=$PWD/bin:$PATH
sleep 5 
for i in install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done
kubectl apply -f install/kubernetes/istio-demo-auth.yaml

sleep 200
## HABILITANDO ISTIO INJECTION NO NAMESPACE DEFAULT 
kubectl label namespace default istio-injection=enabled

sleep 3

echo "${LIGHT_BLUE}Implantando Bookinfo App${NC}"
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/bookinfo.yaml
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/bookinfo-gateway.yaml
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/destination-rule-all-mtls.yaml
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/virtualservice-reviews-escopo2.yaml
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/policy-ratelimit-clientside-escopo3.yaml
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/policy-ratelimit-mixerside-escopo3.yaml

echo "${LIGHT_BLUE}Execucao encerrada!{NC}"
