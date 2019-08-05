echo "Verificando instalação do Microk8s"
PROGRAMA=$(type microk8s | grep microk8s | wc -l)
if [ $PROGRAMA -eq 0 ]
then
echo "Instalando microk8s"
sudo snap install microk8s --classic
else
echo "Microk8s já está instalado"
fi

echo "Configurando Alias para Kubectl"
sudo snap alias microk8s.kubectl kubectl

echo "Adicionando Regras de Firewall"
sudo ufw default allow routed
sudo iptables -P FORWARD ACCEPT

echo "Habilitando Dashboard, DNS e Metrics-Server" 
sudo microk8s.enable dns dashboard metrics-server  
sudo ufw allow in on cbr0 && sudo ufw allow out on cbr0 # Dns e Dashboar com CrashLopping
sleep 5

echo "Habilitando Istio"
sudo microk8s.enable istio 

#echo "Criando namespace Bookinfo"
#kubectl create namespace bookinfo-app

echo "Habilitando o istio-injection no namespace"
kubectl label namespace default istio-injection=enabled

echo "Implantando aplicação"
kubectl create -f https://raw.githubusercontent.com/istio/istio/release-1.2/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl create -f https://raw.githubusercontent.com/istio/istio/release-1.2/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.2/samples/bookinfo/networking/destination-rule-all-mtls.yaml

