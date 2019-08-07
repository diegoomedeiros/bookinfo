#!/bin/sh
set -e
LIGHT_BLUE='\033[1;34m'
NC='\033[0m'
IP_RANGE"192.168.15.100-192.168.15.105"

echo
echo
echo "${LIGHT_BLUE}Verificando instalação do Microk8s${NC}"
echo
PROGRAMA=$(type microk8s.status 2>/dev/null | wc -l)
if [ $PROGRAMA -eq 0 ]
	then		
		echo "${LIGHT_BLUE}Instalando microk8s${NC}"
		snap install microk8s --classic --channel=1.14/stable
	else
	echo "${LIGHT_BLUE}Microk8s já está instalado${NC}"
fi
sudo snap alias microk8s.kubectl kubectl
echo "${LIGHT_BLUE}Configurando permissoes de execucao (Eternal Pending Status)${NC}"
echo
echo "--allow-privileged=true" 2>/dev/null | sudo tee -a /var/snap/microk8s/current/args/kubelet
echo "--allow-privileged=true" 2>/dev/null | sudo tee -a /var/snap/microk8s/current/args/kube-apiserver
echo
sleep 4
echo "${LIGHT_BLUE}Adicionando Regras de Firewall${NC}" ##Debian/Ubuntu
echo
sudo ufw default allow routed
sudo iptables -P FORWARD ACCEPT
sudo ufw allow in on cbr0 && sudo ufw allow out on cbr0 # Dns e Dashboar com CrashLopping
sleep 2  
#sleep 5
echo "${LIGHT_BLUE}Habilitando Istio${NC}"
microk8s.enable istio 
sudo ufw allow in on cbr0 && sudo ufw allow out on cbr0 # Dns e Dashboar com CrashLopping
sleep 300 || exit ## Tempo medio de inicializacao do Pods do Istio 
#bash <(curl -L https://git.io/getLatestKialiOperator)
echo "${LIGHT_BLUE}Habilitando dns e dashboard${NC}"
microk8s.enable dashboard
sleep 5 || exit
echo
echo
echo "${LIGHT_BLUE}Habilitando o istio-injection no namespace${NC}"
echo
kubectl label namespace defaul istio-injection=enabled
sleep 5
echo
echo
echo "${LIGHT_BLUE}Implantando Bookinfo App${NC}"
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/bookinfo.yaml
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/bookinfo-gateway.yaml
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/destination-rule-all-mtls.yaml
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/virtualservice-reviews-escopo2.yaml
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/policy-ratelimit-clientside-escopo3.yaml
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/policy-ratelimit-mixerside-escopo3.yaml

echo "${LIGHT_BLUE}Execucao encerrada!{NC}"
