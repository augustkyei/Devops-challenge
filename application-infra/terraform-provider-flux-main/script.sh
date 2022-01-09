#!/bin/bash
env=dev
cluster_name=$env-senapt-eks-cluster
git clone git@github.com:senapt/$env-flux-system.git
cd $env-flux-system
cd $cluster_name

flux create source helm senchart \
  --url=http://chartmuseum.senapt.com:8080 \
  --secret-ref=senchart-auth \
  --export > helmrepo-senchart.yaml

flux create helmrelease audit-trail-service \
  --source=HelmRepository/senchart \
  --chart=audit-trail-service \
  --target-namespace=default \
  --chart-version=">1.0.0" \
  --export > helmrelease-audit-trail-service.yaml

git add . 
git commit -m "yamls pushed"
git push origin main
cd
rm -rf $env-flux-system
