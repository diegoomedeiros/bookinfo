# bookinfo





### Grafana
kubectl port-forward svc/grafana 3000:3000 -n istio-system
http://localhost:3000
### Service Graph
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}') 8088:8088 &
http://localhost:8088/force/forcegraph.html
### Jaeger Query
