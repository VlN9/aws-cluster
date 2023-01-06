#!/bin/bash

kubectl $ACTION -f main-deploy.yaml
kubectl $ACTION -f deploy-service.yaml
kubectl $ACTION namespace monitoring
kubectl $ACTION -f clusterRole.yaml
kubectl $ACTION -f config-map.yaml
kubectl $ACTION -f prometheus-deployment.yaml
kubectl $ACTION -f prometheus-service.yaml
kubectl $ACTION -f daemonset.yaml
kubectl $ACTION -f exporter-service.yaml
