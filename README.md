
The core of this project is to provision an EKS Cluster with Fargate as a form of worker Node.

Then cd application-infra / run terraform plan with Param as input environmental variables.

Run Terraform apply to Bootstrap Fluxcd V2 into the cluster.

Flux v2 with Helm is responsible to get our application from GitOps WorkFlow to the cluster. 

................................

cd into this folder ..... Devops-challenge/application-infra/Devops_Challenge/devops_work.yaml

run kubectl apply -f secret.yaml  
This will create the secret for the rest of the application to use. 

.......................................

kind: ServiceAccount
apiVersion: v1
metadata:
  labels:
    k8s-app: devops-challenge
  name: pdb
  namespace: default

---
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: devops-challenge
  name: devops-challenge
  namespace: default
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
  selector:
    k8s-app: devops-challenge

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-challenge
  labels:
    k8s-app: devops-challenge
    app: devops-challenge
spec:
  replicas: 3
  selector:
    matchLabels:
      k8s-app: devops-challenge
      app: devops-challenge
  template:
    metadata:
      name: devops-challenge
      labels:
        k8s-app: devops-challenge
        app: devops-challenge
    spec:
      containers:
        - name: devops-challenge
          image: nginx:latest
          envFrom:
            - secretRef:
                name: api-key
          resources:
            limits:
              cpu: 20m ## 10% of 1 core on your system
      serviceAccountName: pdb


---
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: nginx-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: devops-challenge
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 10
