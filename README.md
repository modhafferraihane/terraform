1- Configure Terraform 
configure backend
configure provider
2- Provision a highly available AWS infrastructure dedicated to a Kubernetes cluster 
internet gateway 
2 private subnet
2 public subnet 
elasticip
1 natgateway
1 private route table
private security group
public security group
 
 
3- Provision a kubernetes cluster and the workers nodes
1 master et 1 worker
4- Install monitoring tools 
5- Deploy Kubernetes manifests

helmtf
kubernetes.tf
network.tf


public subnets 
Key=kubernetes.io/role/elb,Value=1
Key=kubernetes.io/cluster/ops-cluster,Value=owned


private subnets
Key=kubernetes.io/role/internal-elb,Value=1
Key=kubernetes.io/cluster/ops-cluster,Value=owned