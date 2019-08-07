# Desafio Bookinfo - Easy Install

Como sair do 0 a um node local em alguns minutos - ou não.
-Recursos: 
** Snap - (Recomenda-se utilizar SO. Ubuntu com versao de Kernel 4.4 ou superior - vários problemas com outras distros e versões do kernel)


## Istio - Service Mesh

## Kiali - Visualizador de Service Mesh
```kubectl port-forward svc/zipkin 9411:9411 -n istio-system &```
http://localhost:9411/

## Grafana
Ferramenta de visualização e analise de dados/métricas por meio de gráficos (dashboards) dinâmicos (tempo real) que podem ser compartilhados.
-Leve.
-Integração com diversas bases de dado.
Liberando porta no proxy:
```kubectl port-forward svc/grafana 3000:3000 -n istio-system &```
[http://localhost:3000]

## Prometheus


## Helm 

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
