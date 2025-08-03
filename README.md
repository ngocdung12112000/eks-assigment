# AWS EKS Assignment

### 1. Objective
Build and deploy a sample application on Amazon EKS using Terraform for infrastructure and demonstrate:

	· Cluster provisioning with Terraform
	· Application deployment with Kubernetes manifests (YAML)
	· IAM integration using IRSA
	· Autoscaling setup (HPA)
	· Observability (logs and metrics)

### 2. Project Structure
<pre>eks-assignment/
│
├── cluster/
├── kubernetes-manifests/
│    ├── serviceaccount.yaml
│    ├── deployment.yaml
│    ├── service.yaml
│    ├── hpa.yaml
│    └── s3-test-pod.yaml
├── modules/
│	├── eks/
│	│	├── iam-policies/
│	│	│	└── s3-readonly-policy.json
│	│	├── iam.tf
│	│	├── main.tf
│	│	├── outputs.tf
│	│	└── variables.tf
│	└── vpc_and_subnets/
│		├── main.tf
│		├── outputs.tf
│		└── variables.tf
├── main.tf
├── variables.tf
└── sample.tfvars.tf </pre>

### 3. Deployment Steps
#### &nbsp;&nbsp;&nbsp;&nbsp;3.1 Provision Infrastructure
Initialize and apply Terraform:
<pre>
terraform init
terraform plan
terraform apply -auto-approve
</pre>
![P1](/images/p1.png "p1")
![P2](/images/p2.png "p2")
![P3](/images/p3.png "p3")
![P4](/images/p4.png "p4")


Update kubectl config:
<pre>
aws eks --region ap-southeast-1 update-kubeconfig --name eks-sample
kubectl get nodes
</pre>
![P5](/images/p5.png "p5")

#### &nbsp;&nbsp;&nbsp;&nbsp; 3.2 Deploy Metrics Server
Required for HPA:
<pre>
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
</pre>
![P6](/images/p6.png "p6")

#### &nbsp;&nbsp;&nbsp;&nbsp; 3.3 Deploy Application + IRSA
Deploy Service Account, Nginx Deployment, Service, and HPA:
<pre>
kubectl apply -f kubernetes-manifests/serviceaccount.yaml
kubectl apply -f kubernetes-manifests/deployment.yaml
kubectl apply -f kubernetes-manifests/service.yaml
kubectl apply -f kubernetes-manifests/hpa.yaml
</pre>
Verify service:
<pre>
kubectl get svc
</pre>
![P7](/images/p7.png "p7")

Access the LoadBalancer endpoint in a browser
![P8](/images/p8.png "p8")
#### &nbsp;&nbsp;&nbsp;&nbsp; 3.4 Test HPA Scaling
Check initial CPU usage and replica count:
<pre>
kubectl top pods
</pre>
Generate load:
<pre>
kubectl run -i --tty load-generator --image=busybox /bin/sh
# Inside the pod:
while true; do wget -q -O- http://nginx-service; done
</pre>
Check HPA status:
<pre>
kubectl get hpa
kubectl top pods
</pre>
![P9](/images/p9.png "p9")
#### &nbsp;&nbsp;&nbsp;&nbsp; 3.5 Observability (Logs and Metrics)
Check logs of a pod:
<pre>
kubectl get pods
kubectl logs nginx-deployment-78f76d5775-d4jld
</pre>
![P10](/images/p10.png "p10")

### 5. IAM Integration (IRSA) & S3 Test Pod
Deploy the S3 test pod:
<pre>
kubectl apply -f kubernetes-manifests/s3-test-pod.yaml
kubectl get pods
kubectl exec -it s3-test-pod -- bash
aws s3 ls
</pre>
![P11](/images/p11.png "p11")
![P12](/images/p12.png "p12")


