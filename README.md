
The core of this project is to provision an EKS Cluster with Fargate as a form of worker Node.

Then cd application-infra / run terraform plan with Param as input environmental variables.

Run Terraform apply to Bootstrap Fluxcd V2 into the cluster.

Flux v2 with Helm is responsible to get our application from GitOps WorkFlow to the cluster. 

Manual Deployments 

