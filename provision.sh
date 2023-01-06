#!/bin/bash

eksctl $ACTION cluster -f cluster.yaml
kubectl $ACTION -f main-deploy.yaml
kubectl $ACTION -f deploy-service.yaml
kubectl $ACTION namespace monitoring
kubectl $ACTION -f clusterRole.yaml
kubectl $ACTION -f config-map.yaml
kubectl $ACTION -f prometheus-deployment.yaml
kubectl $ACTION -f prometheus-service.yaml
kubectl $ACTION -f daemonset.yaml
kubectl $ACTION -f exporter-service.yaml

export MONITORING_ELB=`kubectl get service -n monitoring | grep -o "[(a-z)(0-9)-.]*.elb.amazonaws.com"`
export APP_ELB=`kubectl get service | grep -o "[(a-z)(0-9)-.]*.elb.amazonaws.com"`
export REGION_ZONE_ID=`aws elb describe-load-balancers --region eu-west-2 | grep -wo -m 1 "Z[(A-Z)(0-9)]*"`

aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '
{
  "Comment": "Creating Alias resource record sets in Route 53"
 ,"Changes": [{
    "Action": "CREATE"
   ,"ResourceRecordSet": {
      "Name": "web-apache.'"$HOSTED_ZONE_NAME"'"
     ,"Type": "A"
     ,"AliasTarget": {
        "HostedZoneId": "'"$REGION_ZONE_ID"'"
       ,"DNSName": "dualstack.'"$APP_ELB"'"
       ,"EvaluateTargetHealth": false
      }
    }
  }
 ,{
    "Action": "CREATE"
   ,"ResourceRecordSet": {
      "Name": "prometheus.'"$HOSTED_ZONE_NAME"'"
     ,"Type": "A"
     ,"AliasTarget": {
        "HostedZoneId": "'"$REGION_ZONE_ID"'"
       ,"DNSName": "dualstack.'"$MONITORING_ELB"'"
        "EvaluateTargetHealth": false
      }
    }
  }]
}'
