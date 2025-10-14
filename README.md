# 🚀 DevOps QR Code Generator - EKS, IRSA, Jenkins, Docker, Kubernetes, Terraform

A full-fledged **DevOps project** demonstrating deployment of a containerized QR Code Generator application on **Amazon EKS** with secure S3 access via **IRSA**, full infrastructure provisioning using **Terraform**, and a complete **CI/CD pipeline with Jenkins**.

---

## 📌 Summary

- **Frontend**: Next.js UI to generate QR codes
- **Backend**: FastAPI to handle QR logic and upload to S3
- **Cloud Storage**: AWS S3 (accessed securely via IRSA)
- **Infrastructure**: Terraform modules for VPC + EKS
- **CI/CD**: Jenkins pipeline running on EC2
- **Deployment**: Kubernetes with IRSA-based service accounts

---

## 🧭 Table of Contents

- [📦 Project Overview](#-project-overview)
- [🧱 Architecture / Workflow](#-architecture--workflow)
- [✨ Features](#-features)
- [🧰 Tech Stack](#-tech-stack)
- [🌐 Live Demo](#-live-demo)
- [🧰 Getting Started](#-getting-started)
- [🛠️ Local Development](#️-local-development)
- [🐳 Docker Setup](#-docker-setup-dev--prod)
- [🐳 Docker Compose (Optional)](#-docker-compose-optional)
- [🏗️ Infrastructure as Code (Terraform)](#️-infrastructure-as-code-terraform)
- [⚡ Jenkins CI/CD Pipeline](#-jenkins-cicd-pipeline)
- [☸️ Kubernetes Deployment](#️-kubernetes-deployment)
- [📝 Environment Variables](#-environment-variables)
- [📸 Screenshots](#-screenshots)
- [📚 Learning / Takeaways](#-learning--takeaways)
- [🧹 Cleanup](#-cleanup)
- [📝 License](#-license)

---

## 📦 Project Overview

This application allows users to generate QR codes from input URLs. The backend uses FastAPI to generate the QR code, and stores the image in an AWS S3 bucket. The frontend fetches and displays the generated QR code.

DevOps-QR-Generator/
├── Infra/ # Terraform code for VPC + EKS
├── QR-Generator/ # Frontend & Backend source code
├── K8S-ISRA/ # Kubernetes manifests with IRSA
├── Jenkinsfile # CI/CD pipeline definition
├── server-setup.sh # Jenkins EC2 provisioning script
├── screenshots/ # Output screenshots
└── README.md


---

## 🧱 Architecture / Workflow

```text
User
 │
 ▼
Frontend (Next.js)
 │
 ▼
Backend (FastAPI) ──(IRSA)──▶ IAM Role
        │                     │
        └──▶ AWS S3

✨ Features

✅ Secure QR code generation and public S3 hosting

✅ AWS IRSA for secure access (no hardcoded credentials)

✅ Kubernetes-native deployment on EKS

✅ Full Terraform infra automation (modular)

✅ CI/CD pipeline via Jenkins on EC2

✅ Clean folder separation & microservice architecture

🧰 Tech Stack
Category	Technology
Front-End	Next.js, React
Back-End	Python, FastAPI
Cloud	AWS EKS, S3, IAM
DevOps Tools	Docker, Kubernetes
IaC	Terraform, eksctl
CI/CD	Jenkins
🌐 Live Demo

Use the following to get service URL:

kubectl get svc qr-generator-frontend-service


If using Minikube:

minikube service qr-generator-frontend-service --url

🧰 Getting Started
✅ Prerequisites

Install:

Docker

AWS CLI v2

kubectl

eksctl

Terraform

Git

🖥️ Jenkins EC2 Setup (CI/CD Host)

Provision a t2.small EC2 Ubuntu and run:

bash server-setup.sh


✅ Installs:

Jenkins

Docker

AWS CLI

Terraform

eksctl

kubectl

Reboot EC2 after setup to apply Docker group permissions to Jenkins user.

🛠️ Local Development
🔧 Frontend (Next.js)
cd QR-Generator/front-end-nextjs
npm install
npm run dev

🧪 Backend (FastAPI)
cd QR-Generator/backend-api
pip install -r requirements.txt
uvicorn main:app --reload

🐳 Docker Setup (Dev + Prod)
Backend Dockerfile
FROM python:3.9
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

Frontend Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
CMD ["npm", "start"]

🐳 Docker Compose (Optional)
docker-compose up --build

🏗️ Infrastructure as Code (Terraform)

Terraform code in Infra/ is organized in modules.

Usage
cd Infra/
terraform init
terraform apply -var-file=terraform.tfvars


Creates:

VPC

EKS Cluster

Worker Nodes

⚡ Jenkins CI/CD Pipeline
Jenkinsfile Stages

Terraform Infra Setup

Build & Push Docker Images

Apply Kubernetes Manifests

Wait for Pods Readiness

Destroy (optional)

Trigger Types

Manual (parametrized)

Auto (via Git webhook - TODO)

☸️ Kubernetes Deployment

Kubernetes manifests are in K8S-ISRA/:

kubectl apply -f configmap.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f frontend-deployment.yaml

IRSA Setup

Associate OIDC provider:
IRSA Setup

Associate OIDC provider:

eksctl utils associate-iam-oidc-provider \
  --region ap-south-1 \
  --cluster devops-qr-cluster \
  --approve


Create IAM policy (S3 access) and IAM Role.

Create ServiceAccount:

eksctl create iamserviceaccount \
  --name aws-secrets-sa \
  --cluster devops-qr-cluster \
  --region ap-south-1 \
  --attach-policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/QRGenerator-S3-Policy \
  --approve

📝 Environment Variables

Handled in configmap.yaml or inline in Kubernetes manifests.

Variable	Description
S3_BUCKET	AWS S3 bucket name
AWS_REGION	AWS Region
BASE_URL	Public S3 base path for URLs
📸 Screenshots
UI	QR Output	Jenkins Logs

	
	
📚 Learning / Takeaways

🔐 Mastered IRSA for secure AWS access from EKS

⚙️ Used modular Terraform for clean infra provisioning

☁️ Built and deployed microservices on EKS

🔄 Created full CI/CD pipeline with Jenkins

🧩 Implemented clean separation of concerns (infra/app/cicd)

🧹 Cleanup
Delete Kubernetes Resources
kubectl delete -f backend-deployment.yaml
kubectl delete -f frontend-deployment.yaml
kubectl delete -f configmap.yaml

Delete IRSA IAM Role
eksctl delete iamserviceaccount \
  --name aws-secrets-sa \
  --cluster devops-qr-cluster \
  --region ap-south-1

📝 License

MIT License © 2025 Rahul Paswan

Licensed under the MIT License

📌 TODO / Future Enhancements

 Auto Jenkins trigger via GitHub webhook

 Add Helm chart support

 Integrate auto-scaling for backend

 Add Prometheus + Grafana monitoring