#!/bin/bash
env=dev
cluster_name=$env-senapt-eks-cluster

aws eks --region eu-west-2 update-kubeconfig --name cluster_name
git clone git@github.com:senapt/$env-flux-system.git
cd $env-flux-system
cd $cluster_name

flux create source helm senchart \
  --url=http://chartmuseum.senapt.com:8080 \
  --secret-ref=senchart-auth \
  --export > helmrepo-senchart.yaml

flux create helmrelease s-index-frontend-service \
  --source=HelmRepository/senchart \
  --chart=s-index-frontend-service \
  --target-namespace=default \
  --chart-version=">0.0.1" \
  --export > helmrelease-s-index-frontend-service.yaml



git add . 
git commit -m "yamls pushed"
git push origin main
cd
rm -rf $env-flux-system
