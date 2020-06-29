# Argo CD Multi-Cluster Demo
Inspired by Google Anthos Configuration Manager (ACM) I wondered if I could use 
Argo CD and a repository to auto-configure multiple Kubernetes clusters. This 
repo is my sandbox for testing this theory and playing with different features.

# Architecture
The objective is to connect multiple kubernetes clusters via Argo CD to this repo 
and whenever I push changes in this repo, they will automatically apply the changes.

![Architecture](architecture-argocd-config.png)

# Usage
1. Create or use an existing Google Cloud Platform project
2. Clone this repository to your computer, cd to `multi-cluster-argo-demo`
3. Create a `.env` file in the same directory as `create-k8s-clusters.sh`
```
cat > .env << EOF
export PROJECT_ID=<YOUR PROJECT ID>
export AUTH_NETWORK="<YOUR IP ADDRESS>/32"
EOF
```
4. Execute the bootstrap script `./create-k8s-clusters.sh`
5. Log into your clusters after 8-10 minutes and confirm you have `east` and `west` clusters and both have the configurations in the `k8s-config/` folder.
![Clusters created](gcp-east-west-clusters.png)
![Argo CD installed](gcp-argo-cd-installed.png)
6. Create your own repo and change the `app-of-apps.yaml` to point to your repo instead.
7. Enjoy!

# References
- [Cluster Bootstrapping with App of Apps pattern](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/)
- [Anthos Config Management](https://cloud.google.com/anthos/config-management) (inspiration)



