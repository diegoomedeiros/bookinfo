#!/bin/bash
set -e
LIGHT_BLUE='\033[1;34m'
NC='\033[0m'

MICROK8S_V="1.14/stable"
ISTIO_V="1.1.9"

echo "" 
echo ""
echo -e "${LIGHT_BLUE}Verificando instalação do Microk8s${NC}"
echo ""
PROG=$(type microk8s.status 2>/dev/null | wc -l)
if [ $PROG -eq 0 ]
	then		
		echo -e "${LIGHT_BLUE}Instalando microk8s-$MICROK8S_V ${NC}"
		#sudo snap install microk8s --classic --channel=$MICROK8VS_V
		sudo snap ack ~/repo-microk8s/microk8s_687.assert               #OFFLINE INSTALLATION
		sudo snap install ~/repo-microk8s/microk8s_687.snap --classic   #OFFLINE INSTALLATION 
		sudo snap alias microk8s.kubectl kubectl
	else
	echo -e "${LIGHT_BLUE}Microk8s já está instalado${NC}"
fi
echo ""
echo -e "${LIGHT_BLUE}Correcao  - Eternal Pending Status)${NC}"
echo "--allow-privileged=true" 2>/dev/null | sudo tee -a /var/snap/microk8s/current/args/kubelet
echo "--allow-privileged=true" 2>/dev/null | sudo tee -a /var/snap/microk8s/current/args/kube-apiserver
sleep 2
echo -e "${LIGHT_BLUE}Habilitando DNS${NC}"
echo ""
microk8s.enable dns
sudo ufw allow in on cbr0 && sudo ufw allow out on cbr0 # Dns e Dashboard com CrashLopping
sleep 5
echo ""
echo -e "${LIGHT_BLUE}Adicionando Regras de Firewall${NC}" ##Debian/Ubuntu
sudo ufw default allow routed
sudo iptables -P FORWARD ACCEPT
sleep 2
echo ""
echo -e "${LIGHT_BLUE}Baixando,configurando e instalando o Istio-$ISTIO_V ${NC}"
cd ~
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=$ISTIO_V sh -
cd istio*
export PATH=$PWD/bin:$PATH

for i in install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done
echo ""
kubectl apply -f install/kubernetes/istio-demo-auth.yaml

echo -e "${LIGHT_BLUE}Habilitando o istio-injection no namespace${NC}"
kubectl label namespace default istio-injection=enabled
sleep 5
echo ""
echo -e "${LIGHT_BLUE}Implantando Bookinfo App${NC}"
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/bookinfo.yaml
sleep 2
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/bookinfo-gateway.yaml
sleep 2
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/destination-rule-all-mtls.yaml
sleep 2
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/virtualservice-reviews-escopo2.yaml
sleep 2
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/policy-ratelimit-clientside-escopo3.yaml
sleep 2
kubectl apply -f https://raw.githubusercontent.com/diegoomedeiros/bookinfo/master/app/policy-ratelimit-mixerside-escopo3.yaml
echo ""
echo -e "${LIGHT_BLUE}Aguardando inicializaçao dos PODs${NC}"
sleep 300  ## Tempo medio de inicializacao do Pods do Istio 
echo ""


echo -e "${LIGHT_BLUE}FINALIZADO!${NC}"

