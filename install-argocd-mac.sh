#!/usr/bin/env bash

export PROJECT_ID=mike-production
export CLUSTER_NAME=test-cluster
export REGION=us-central1
export ZONE=us-central1-c
export ARGOCD_OPTS='--port-forward-namespace argocd'

# install argcocd on local machine
brew tap argoproj/tap
brew install argoproj/tap/argocd

# make sure project and permissions set
gcloud config set project $PROJECT_ID
gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION
kubectl config current-context

# install argocd on GKE cluster
kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin --user="$(gcloud config get-value account)"
kubectl create namespace argocd
kubectl apply -n argocd \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# port forward (for now) to access argocd UI
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

# fetch initial password (auto generated)
export ARGO_PASS=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)
echo "Argo default pass: ${ARGO_PASS}"

# authenticate argocd
argocd login --insecure localhost:8080 --username admin --password $ARGO_PASS

# optionally change password
# argocd account update-password

# configure current cluster
argocd cluster add $(kubectl config current-context)

# install demo guestbook app
argocd app create guestbook \
    --repo https://github.com/argoproj/argocd-example-apps.git \
    --path guestbook \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace default

# view app info
argocd app get guestbook

# sync cluster with repo
argocd app sync guestbook

# create app of apps

# create projects

# create users

# integrate auth with IdP
