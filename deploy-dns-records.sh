#!/bin/bash

export MONITORING_ELB=`kubectl get service -n monitoring | grep -Ewo "[a-z0-9\-]*.\w{2}-\w{4,10}-[1-3].elb.amazonaws.com"`
export APP_ELB=`kubectl get service | grep -Ewo "[a-z0-9\-]*.\w{2}-\w{4,10}-[1-3].elb.amazonaws.com"`
export REGION_ZONE_ID=`aws elb describe-load-balancers --region eu-west-2 | grep -wo -m 1 "Z[(A-Z)(0-9)]*"`

echo $MONITORING_ELB
echo $APP_ELB

aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '
{
  "Comment": "Creating Alias resource record sets in Route 53"
 ,"Changes": [{
    "Action": "'"$RECORD_ACTION"'"
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
    "Action": "'"$RECORD_ACTION"'"
   ,"ResourceRecordSet": {
      "Name": "prometheus.'"$HOSTED_ZONE_NAME"'"
     ,"Type": "A"
     ,"AliasTarget": {
        "HostedZoneId": "'"$REGION_ZONE_ID"'"
       ,"DNSName": "dualstack.'"$MONITORING_ELB"'"
       ,"EvaluateTargetHealth": false
      }
    }
  }]
}'


