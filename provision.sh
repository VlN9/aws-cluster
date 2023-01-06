#!/bin/bash

if [ "$ACTION" == "create" ]; then
    eksctl $ACTION cluster -f cluster.yaml
    ./kubectl-action.sh
    export RECORD_ACTION="CREATE"
    ./deploy-dns-record.sh
else
    eksctl $ACTION cluster -f cluster.yaml
    export RECORD_ACTION="DELETE"
    ./deploy-dns-record.sh
