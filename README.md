# Desafio Bookinfo - Easy Install

Como sair do 0 a um node local em alguns minutos - ou não.

-Recursos: 
**Snap - (Recomenda-se utilizar sistema operacional Ubuntu com versao de Kernel 4.4 ou superior - vários problemas com outras distros e versões do kernel)
Só?! Easy_intall faz o resto!

# Conjunto de aplicações a serem instalados no Cluster
 * [Istio]
 * [Kiali]
 * [Grafana]
 * [Prometheus]
 

## Istio - Service Mesh 

Fornece uma vasta gama de recursos para gestão de microservicos distribuidos com diversas integrações. Tem como principal objetivo, reduzir a complexidade no processo de implantação para os times de desenvolvimento. Atua no gerenciamento de trafego, segurança, integração e visibilidade.  

## Kiali - Visualizador de Service Mesh

É uma plataforma que mapeia praticamente todos os elementos que compõem um service mesh - Tem forte integração com o Istio. 
Nesta ferramenta é possível ver gráficos com fluxo de dados, logs, status de serviços e PODs, consumo de processamento e memória, fluxo de requisições, uso de conexões,etc. Ainda permite váriar as dimensões entre nós, aplicações, namespaces, Pods, e por ai vai. 
Comando de bypass:
```kubectl port-forward svc/zipkin 9411:9411 -n istio-system &```  -->  [http://localhost:9411/]

## Grafana
Ferramenta de visualização e analise de dados/métricas por meio de gráficos (dashboards) dinâmicos (tempo real) que podem ser compartilhados. É utilizado como dependência pelo Kiali.
-Leve.
-Integração com diversas bases de dado.
Comando de bypass:
```kubectl port-forward svc/grafana 3000:3000 -n istio-system &``` ---> [http://localhost:3000]

## Prometheus
È um sistema de monitoramento e alarme que provem modelos de dados multidimensionais com marcações de tempo. Neste caso, fornece a base de dados para o Grafana e Kiali.

## Helm (Opcional)
Gerenciador de pacotes - Sua função é permitir atualizações mais rápidas e mapear dependências entre as ferrametas de Service Mesh.

## MetalLB  (Opcional)
  Fornece IP (Layer2) para o Ingress do Istio em ambientes internos- faz o papel de um Load Balencer Externo.
  Intalação:
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
  Configuração - indique um range de IPs disníveis na mesma faixa do nó na chave addresses.(Ex. - 192.168.15.20-192.168.15.21)

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.15.20-192.168.15.21
EOF




### Referências
 * MICROK8S / KUBERNETES / DASHBOARD /etc
 
https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0
https://kubernetes.io/docs/concepts/overview/working-with-objects/object-management/
https://kubernetes.io/docs/tutorials/#ci-cd-pipeline
https://kubernetes.io/docs/tutorials/kubernetes-basics/
https://kubernetes.io/docs/tasks/
https://medium.com/@bluszcz/serverless-microk8s-kubernetes-fcd6b875cd33
https://virtualizationreview.com/articles/2019/01/30/microk8s-part-2-how-to-monitor-and-manage-kubernetes.aspx
https://github.com/ubuntu/microk8s/blob/master/docs/community.md
https://www.b2-4ac.com/kubernetes-in-seconds-microk8s/
https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
https://itnext.io/microk8s-puts-up-its-istio-and-sails-away-104c5a16c3c2

 * ISTIO
https://istio.io/docs/examples/bookinfo/
https://istio.io/docs/setup/kubernetes/install/kubernetes/
https://istio.io/docs/tasks/traffic-management/request-routing/
https://istio.io/docs/reference/config/networking/v1alpha3/destination-rule/

 * KIALI
https://www.kiali.io/documentation/features/#_detail_services
https://www.kiali.io/documentation/getting-started/
https://medium.com/kialiproject/visualizing-istio-external-traffic-with-kiali-9cba75b337f4
https://blog.getupcloud.com/desbravando-o-helm-com-istio-e-kiali-bf2cfd724c39


 * METALLB 
https://kubernetes.github.io/ingress-nginx/deploy/baremetal/#a-pure-software-solution-metallb
https://dzone.com/articles/kubernetes-metallb-bare-metal-loadbalancer
https://medium.com/@emirmujic/istio-and-metallb-on-minikube-242281b1134b
https://tutorials.ubuntu.com/tutorial/install-a-local-kubernetes-with-microk8s#5
https://www.sanisimov.com/2019/02/using-coredns-metallb-on-bare-metal-kubernetes-clusters/
https://gist.github.com/caglar10ur/1ef975bdf2d5a8e1848e46408d5b8d64

