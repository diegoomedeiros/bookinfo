echo "Instalando microk8s"
sudo snap install microk8s --classic
echo "Configurando Alias para Kubectl"
sudo snap alias microk8s.kubectl kubectl

echo "Habilitando Istio e DNS"
sudo microk8s.enable istio  && sleep 5

echo "Habilitando Dashboard"
sudo microk8s.enable dashboard

echo "Configurando aliases"
sudo snap alias microk8s.kubectl kubectl
sudo snap alias microk8s.istioctl istioctl


echo "Criando namespace Bookinfo"
kubectl create namespace bookinfo

echo "Habilitando o istio-injection no namespace"
kubectl label namespace bookinfo istio-injection=enabled

echo "Implantando aplicação"
kubectl apply -f 

