# Desafio Bookinfo

Como sair do 0 a um node local em alguns minutos.




### Grafana - 
- Leve 
- Comunidade ativda
- Integração
```kubectl port-forward svc/grafana 3000:3000 -n istio-system &
[http://localhost:3000]
### Service Graph
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}') 8088:8088 &
http://localhost:8088/force/forcegraph.html
### Kiali
kubectl port-forward svc/zipkin 9411:9411 -n istio-system
http://localhost:9411/


### MetalLB 
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
