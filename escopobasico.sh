set -e
LIGHT_BLUE='\033[1;34m'
NC='\033[0m'
echo ""
echo ""
echo -e "${LIGHT_BLUE}Verificando instalação do Microk8s${NC}"
echo ""
PROGRAMA=$(type microk8s | grep microk8s | wc -l)
if [ $PROGRAMA -eq 0 ]
then
echo -e "${LIGHT_BLUE}Instalando microk8s${NC}"
snap install microk8s --classic --channel=1.16/edge
else
echo -e "${LIGHT_BLUE}Microk8s já está instalado${NC}"
fi

echo ""
echo ""
echo -e "${LIGHT_BLUE}Configurando Alias para Kubectl${NC}"
echo ""
sudo snap alias microk8s.kubectl kubectl
sleep 5
echo ""
echo ""
echo -e "${LIGHT_BLUE}Configurando permissoes${NC}"
echo ""
echo "--allow-privileged=true" | sudo tee -a /var/snap/microk8s/current/args/kubelet
echo "--allow-privileged=true" | sudo tee -a /var/snap/microk8s/current/args/kube-apiserver
echo ""
echo ""
sleep 4
echo -e "${LIGHT_BLUE}Adicionando Regras de Firewall${NC}" ##Debian/Ubuntu
echo ""
sudo ufw default allow routed
sudo iptables -P FORWARD ACCEPT

#echo "Habilitando Dashboard, DNS e Metrics-Server" 
#sudo microk8s.enable dns dashboard metrics-server  
#sudo ufw allow in on cbr0 && sudo ufw allow out on cbr0 # Dns e Dashboar com CrashLopping
#sleep 5
echo ""
echo ""
echo -e "${LIGHT_BLUE}Habilitando Istio${NC}"
echo ""
microk8s.enable istio 
sleep 5

#echo "${LIGHT_BLUE}Criando namespace Bookinfo${NC}"
#kubectl create namespace bookinfo-app
echo ""
echo ""
echo -e "${LIGHT_BLUE}Habilitando o istio-injection no namespace${NC}"
echo ""
kubectl label namespace default istio-injection=enabled
sleep 5
echo ""
echo ""
echo -e "${LIGHT_BLUE}Implantando aplicação${NC}"
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.2/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.2/samples/bookinfo/networking/bookinfo-gateway.yaml
#kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.2/samples/bookinfo/networking/destination-rule-all-mtls.yaml





