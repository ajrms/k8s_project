#!/usr/bin/env bash

cd ~
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 get_helm.sh
./get_helm.sh

kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
sleep 20
# 방법 1
# helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

# 방법 2
wget https://raw.githubusercontent.com/grafana/helm-charts/main/charts/grafana/values.yaml
helm install prometheus prometheus-community/kube-prometheus-stack -f "values.yaml" --namespace monitoring

sleep 60

cat <<EOF | sudo tee port.sh
#!/usr/bin/env bash
nohup kubectl port-forward service/prometheus-grafana --address 0.0.0.0 3000:80 --namespace monitoring &
EOF

chmod 700 port.sh