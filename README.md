# aws-cluster

If you don't have already install eksctl and kubestl folow this guides,
eksctl: https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html
kubectl: https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
Also you need active account in AWS. 


After that you need folow next steps:

1. Step one. 
Export your access keys and default region.

$ export AWS_ACCESS_KEY_ID=your_access_key_id
$ export AWS_SECRET_ACCESS_KEY=your_secret_access_key
$ export AWS_DEFAULT_REGION=your_work_region

2. Step two.
Deploying cluster:

$ eksctl create cluster -f cluster.yaml

it's may take a 15-20 minutes. 

3. Step three.
Deploying two simple web-app in our cluster:

$ kubectl create deploy -f main-deploy.yaml

4. Step four.
Create servise load balancer type for our simple web-app

$ kubectl create -fdeploy-service.yaml

5. Step five.
Setup prometheus monitoring system in our kubernetes cluster.
Create namespace:
prometheus-deployment.yaml
$ kubectl create namespace monitoring

Create role:

$ kubectl create -f clusterRole.yaml

Create config map for our cluster:

$ kubectl -f config-map.yaml

Next we created Prometheus deployment and his service:

$ kubectl create -f prometheus-deployment.yaml
$ kubectl create -f prometheus-service.yaml

6. Step six.
Createing nod-exporter and his servise:

$ kubectl create -f daemonset.yaml
$ kubectl create -f exporter-service.yaml

Congrats, your cluster with two simple web-app, them service and reade to use Prometheus monitoring system already created.

You can chek your pods with web-app using next command:

$ kubectl get pod

Them service is available whis next command: 

$ kubectl get svc

To check your monitoring pods and servise use next commands:

$ kubectl get pod -n monitoring 
$ kubectl get svc -n monitoring

