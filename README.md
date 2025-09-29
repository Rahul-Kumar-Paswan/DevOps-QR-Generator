# 🖥️ DevOps QR Code Generator

A full-stack DevOps project that generates QR codes for any URL, showcasing containerization, CI/CD, Kubernetes orchestration, AWS integration, and secret management.

---

## 🚀 Project Overview

This project demonstrates a complete DevOps workflow:

- **Frontend:** Next.js application for URL input and QR code display.  
- **Backend:** FastAPI service generates QR codes and stores them in AWS S3.  
- **Containerization:** Dockerized backend and frontend.  
- **CI/CD:** Jenkins pipeline builds, tests, and deploys Docker images.  
- **Orchestration:** Kubernetes manifests for frontend and backend with configurable secrets.  
- **Secrets Management:** Kubernetes secrets or AWS Secrets Manager for sensitive data.  

---

## 🧩 Architecture Diagram / Workflow

(You can replace this with your actual diagram)

[User] --> [Next.js Frontend] --> [FastAPI Backend] --> [AWS S3]
                      |                       |
                      v                       v
               [Docker / Docker Compose]   [Kubernetes / AWS EKS]

---

## 🛠️ Tech Stack

| Layer            | Technology                             |
| ---------------- | -------------------------------------- |
| Frontend         | Next.js, React, TailwindCSS            |
| Backend          | Python, FastAPI, qrcode, boto3         |
| Containerization | Docker, Docker Compose                 |
| CI/CD            | Jenkins, GitHub                        |
| Orchestration    | Kubernetes                             |
| Cloud            | AWS S3, AWS Secrets Manager (optional) |
| IaC              | Terraform (EKS, VPC, IAM roles)        |

---

## ⚙️ Features

- Generate QR codes for any URL.  
- Store QR codes securely in AWS S3.  
- Dockerized backend and frontend for consistent environments.  
- CI/CD pipeline builds, pushes Docker images, and deploys to Kubernetes automatically.  
- Optional AWS Secrets Manager integration for secure secrets.  
- Fully configurable environment variables for backend URL, AWS keys, and S3 bucket.

---

## 📝 Getting Started

### Prerequisites

- Docker & Docker Compose  
- Node.js & npm  
- Python 3.9+  
- AWS account & S3 bucket  
- `kubectl` & Helm (for Kubernetes deployment)  
- Jenkins (optional for CI/CD)  
- Terraform

---

## 🛠️ Local Development

### Backend

```bash
    cd QR-Generator/backend
    docker build -t qr-generator-backend:local .
    docker run -it -p 8000:80 --env-file .env qr-generator-backend:local
```
### Frontend
bash ```
    cd QR-Generator/frontend
    docker build -t qr-generator-frontend:local .
    docker run -it -p 3000:3000 qr-generator-frontend:local

## 🐳 Docker Compose
bash ```
    docker-compose up --build

Access frontend: http://localhost:3000

Backend URL is automatically linked via service name backend in Docker Compose.

## 🏗️ Infrastructure as Code (Terraform)

- Terraform provisions AWS infrastructure:
  - VPC with public & private subnets
  - Internet Gateway, Route Tables
  - EKS Cluster with Node Groups
  - IAM roles for cluster & nodes
- Store Terraform state in S3 bucket (remote backend)
- Manage environment-specific variables via `terraform.tfvars`

## ⚡ Jenkins CI/CD Pipeline

- Builds and tags Docker images for backend & frontend
- Pushes images to DockerHub or private registry
- Updates Kubernetes manifests and deploys to EKS
- Can optionally provision infrastructure via Terraform (`create`/`destroy`)
- Post-deployment checks ensure pods & services are ready
- Secrets handled securely via Jenkins credentials (AWS keys, Docker credentials)


## ☸️ Kubernetes Deployment
### With Local Secrets
bash ```
    kubectl apply -f Kubernetes/secret.yaml
    kubectl apply -f Kubernetes/backend-deploy.yaml
    kubectl apply -f Kubernetes/front-end-deploy.yaml

### With AWS Secrets Manager

1. Install Secrets Store CSI Driver:
bash ```
    helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
    helm repo update
    helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system

2. Configure secret-provider.yaml and attach IAM role.


    ## 📝 Environment Variables

| Name                  | Description                                        | Type     |
| --------------------- | -------------------------------------------------- | -------- |
| `AWS_ACCESS_KEY`      | AWS access key (secret, use Jenkins credentials)   | Secret   |
| `AWS_SECRET_KEY`      | AWS secret key (secret, use Jenkins credentials)   | Secret   |
| `aws_bucket_name`     | S3 bucket name for storing QR codes                | Config   |
| `BACKEND_URL`         | Backend API URL used by frontend                   | Config   |
| `DOCKER_REGISTRY`     | DockerHub / registry to push images                | Config   |
| `K8S_CLUSTER_NAME`    | Name of EKS cluster                                | Config   |
| `BUILD_TAG`           | CI/CD build number or tag for Docker images        | Config   |



## 💡 Recommendations / Notes

For production, use AWS Secrets Manager instead of hardcoded secrets.

Use ConfigMaps for non-sensitive variables like backend URL.

Follow consistent naming for Docker images, Kubernetes resources, and folders.

Backend service must be reachable from frontend via the same URL configured in BACKEND_URL.

## 📈 Learning / Takeaways

Hands-on experience with Docker, Kubernetes, and CI/CD pipelines.

Learn how to connect frontend and backend services in multiple environments.

Explore AWS S3 storage and secure Secrets Management.

Understand Terraform for infra provisioning and Jenkins for automation.


## 🔗 Live Demo / Portfolio Screenshots

(You can add screenshots or link to live deployment once you run the full stack.)

## 📝 License

MIT License © 2025 Rahul Paswan
This project is licensed under the [MIT License](./LICENSE).