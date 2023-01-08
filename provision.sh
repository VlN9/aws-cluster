#!/bin/bash

if [ "$ACTION" == "create" ]; then
    eksctl $ACTION cluster -f cluster.yaml
    ./kubectl-action.sh
    export RECORD_ACTION="CREATE"
    ./deploy-dns-records.sh
else
    export RECORD_ACTION="DELETE"
    ./deploy-dns-records.sh
    eksctl $ACTION cluster -f cluster.yaml
fi
