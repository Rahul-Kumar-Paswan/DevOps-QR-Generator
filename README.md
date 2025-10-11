# 🚀 DevOps QR Code Generator - Kubernetes Deployment

This project demonstrates how to deploy a **QR Code Generator** application on **Kubernetes**.

The solution consists of two main components:

- **Front-End**: A web application built with **Next.js** for user interaction.
- **Back-End API**: A **Python FastAPI**-based server that accepts URLs, generates corresponding QR codes, and stores them in **AWS S3** for cloud storage.

The project is **containerized using Docker** and deployed using **Kubernetes**, leveraging objects like **Deployments**, **Services**, **ConfigMaps**, and **Secrets**.

---

## 📦 Project Overview

The **DevOps QR Code Generator** utilizes containerization and Kubernetes to deploy a scalable application. It demonstrates key DevOps principles including:

- Containerization
- Cloud storage with AWS S3
- Kubernetes deployment strategies

### 🖥️ Front-End
- React-based web application built with **Next.js**.

### 🧠 Back-End
- API built with **FastAPI** that generates QR codes from URLs.

### ☸️ Kubernetes
- Orchestrates the deployment of both front-end and back-end containers.

### ☁️ AWS S3
- Stores generated QR code images for public access.

---

## ⚙️ Architecture Overview

- **Front-End**: Next.js application that interacts with the FastAPI back-end for QR code generation.
- **Back-End**: FastAPI service that processes URL requests, generates QR codes, and uploads them to AWS S3.
- **Kubernetes**: Application is deployed in two pods (front-end and back-end), with their respective services exposed.
- **AWS S3**: Used for persistent storage of generated QR codes.

---

## 🔧 Prerequisites

Before deploying the application, ensure the following tools are installed:

- 🐳 **Docker** – For building container images.
- ☸️ **Kubernetes (kubectl)** – To interact with the Kubernetes cluster.
- 🖥️ **Minikube** – For running a local Kubernetes cluster.
- 🌩️ **AWS CLI** – For interacting with AWS S3 and other services.
- 🧬 **Git** – To clone the repository.

---

## ☁️ Setting Up AWS S3 for Storage

Follow these steps to set up your AWS S3 bucket:

1. **Create an S3 Bucket**  
   - Go to the [AWS S3 Console](https://s3.console.aws.amazon.com/).
   - Create a bucket (e.g., `devops-qr-code-bucket`).

2. **Configure Bucket Policy**  
   Allow public read access to stored QR codes:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "PublicReadGetObject",
         "Effect": "Allow",
         "Principal": "*",
         "Action": "s3:GetObject",
         "Resource": "arn:aws:s3:::your-bucket-name/qr_codes/*"
       }
     ]
   }
  ```
---

## 🏃‍♂️ Running Locally on Kubernetes (Minikube)

To run the **QR Code Generator** on a local Kubernetes cluster using **Minikube**, follow these steps:

### 1. Clone the Repository

```bash
git clone <repository_url>
cd DevOps-QR-Generator-Kubernetes
```
### 2. Set Up AWS Credentials

Ensure your AWS credentials are configured on your local machine using the **AWS CLI**:

```bash
aws configure
```

### 3. Apply Kubernetes Resources

Navigate to the Kubernetes directory and apply the Kubernetes manifests:

```bash
kubectl apply -f . -n prod
```
This will create the following resources in the `prod` namespace:

- 🐳 **Deployments** for the front-end and back-end  
- 🌐 **Services** to expose both components  
- ⚙️ **ConfigMap** for application configuration  
- 🔐 **Secrets** for securely storing AWS credentials


### 4. Expose the Services

If you are using **Minikube**, you can access the front-end service with the following command:

```bash
minikube service qr-generator-frontend-service -n prod --url
```
This will output the URL of the front-end service, for example:
http://127.0.0.1:46657

👉 Open this URL in your browser to interact with the QR Code Generator.

### 5. Verify the Deployment

To verify that all components are running correctly, use the following command:

```bash
kubectl get all -n prod
```

## 🔄 Troubleshooting

If you're unable to access the frontend via Minikube, ensure that:

- The service is correctly exposed.
- You are using the correct URL from the `minikube service` command.

To check logs for any potential errors, run:

```bash
kubectl logs <pod-name> -n prod
```

## 🛑 Stopping the Services

To stop the services and clean up the resources, run:

```bash
kubectl delete -f . -n prod
```

## 🧑‍💻 Development and Customization

Feel free to customize the project according to your needs. You can:

- Update the Dockerfiles for both the frontend and backend.
- Modify the FastAPI code to handle different types of requests.
- Change the Next.js front-end to suit your preferences.

---

## 📝 License

MIT License © 2025 Rahul Paswan
This project is licensed under the [MIT License](./LICENSE).