#!/bin/bash

if [ "$ACTION" == "create" ]; then
    eksctl $ACTION cluster -f cluster.yaml
    ./kubectl-action.sh
    export RECORD_ACTION="CREATE"
    ./deploy-dns-records.sh
else
    eksctl $ACTION cluster -f cluster.yaml
    export RECORD_ACTION="DELETE"
    ./deploy-dns-records.sh
fi
