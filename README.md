<a id="achor"></a>
# aws-cluster
### What is it
  This project is test of possibility integration  Elastic Kubernetes Services an Prometheus monitoring system.<br>
  This is config of simple cluster consists of two apache servers which is based on vladimir99/apache-alpine images and Prometheus monitoring system which is based  on prom/prometheus image for Prometheus and prom/node-exporter image for node-exporter sytem.
  ### What do you need
  * Account in AWS
  * Installed eksctl tool
  * Installed kubectl tool

If you don't have already installed eksctl and kubestl folow this guides,

[eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

[kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)
***

### After that you need folow next steps:

__Step one__ 

Export your access keys and default region.

```
$ export AWS_ACCESS_KEY_ID=your_access_key_id
```
```
$ export AWS_SECRET_ACCESS_KEY=your_secret_access_key
```
```
$ export AWS_DEFAULT_REGION=your_work_region
```

__Step two__

Deploying cluster:
```
$ eksctl create cluster -f cluster.yaml
```
> _NOTE_<br>
> It's may take a 15-20 minutes. 

__Step three__

Deploying two simple web-apps in our cluster:
```
$ kubectl create deploy -f main-deploy.yaml
```
__Step four__

Create servise load balancer type for our apps
```
$ kubectl create -fdeploy-service.yaml
```
__Step five__

Setup prometheus monitoring system in our kubernetes cluster.

Create namespace:
```
$ kubectl create namespace monitoring
```
Create role:
```
$ kubectl create -f clusterRole.yaml
```
Create config map for cluster:
```
$ kubectl -f config-map.yaml
```
Next we created Prometheus deployment and his service:
```
$ kubectl create -f prometheus-deployment.yaml
```
```
$ kubectl create -f prometheus-service.yaml
```
__Step six__

Createing nod-exporters and his endpoints:
```
$ kubectl create -f daemonset.yaml
```
```
$ kubectl create -f exporter-service.yaml
```
---
Congrats, your cluster with two simple web-apps and ready to use Prometheus monitoring system already created.
>All web-app and also Prometheus available in your Load Balancers You can check this here: <br>
[To get web-apps LB](#web-app) <br>
[To get Prometheus](#pometheus)

Also you can chek your pods with web-apps using next command:
```
$ kubectl get pod
```
<a id="web-app"></a>
Them service is available whith next command: 
```
$ kubectl get svc
```
To check your monitoring pods and servises use next commands:
```
$ kubectl get pod -n monitoring 
```
<a id="prometheus"></a>
```
$ kubectl get svc -n monitoring
```
[_scrollup_](#anchor)
