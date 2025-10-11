# DevOps QR Code Generator - Dockerized Version

This project is part of the **DevOps Capstone Project**, designed to generate QR codes for provided URLs. The solution consists of two main components:

- **Front-End**: A web application built with **Next.js** for user interaction.
- **Back-End API**: A **Python FastAPI**-based server that accepts URLs, generates corresponding QR codes, and stores them in **AWS S3** for cloud storage.

This version of the project has been **Dockerized** to facilitate easy deployment and scalability.

---

## Project Overview

The **DevOps QR Code Generator** is designed to demonstrate several key DevOps principles, including **containerization**, **cloud infrastructure**, **CI/CD pipelines**, and **monitoring**.

This version of the project utilizes **Docker** for containerization to deploy both the **Back-End API** and **Front-End** in isolated environments, making it easier to manage dependencies and deployments.

---

# ⚙️ Architecture

The architecture of the QR Code Generator includes the following components:

## 🖥️ Next.js Front-End
A React-based web application where users input URLs to generate corresponding QR codes.  
The front-end communicates with the FastAPI back-end to process the URLs and generate the QR codes.

## ⚙️ FastAPI Back-End
A Python-based API that:
- Accepts URL requests
- Generates QR codes
- Uploads the images to AWS S3 for storage

## 🐳 Docker
Both the front-end and back-end components are containerized using Docker, ensuring consistent environments across different systems and simplifying deployment.

## ☁️ AWS S3
Used to store the generated QR code images.  
The application interacts with AWS services to provide persistent and scalable storage.

---

# ✅ Prerequisites

Before deploying this application with Docker, ensure the following tools are installed:

## 🐳 Docker
Used to build and run Docker containers.

## 🧩 Docker Compose
Used to manage multi-container applications.

## ☁️ AWS CLI
Required for interacting with AWS services and setting up the S3 bucket.

## 🔧 Git
Used to clone the project repository.

---

# 🪣 AWS S3 Setup

To store the generated QR codes, you will need to set up an S3 Bucket. Follow these steps to configure your AWS S3 bucket:

## Steps to Set Up the S3 Bucket

### 1. Create an S3 Bucket

- Go to the [AWS S3 Console](https://s3.console.aws.amazon.com/s3/)
- Click **Create bucket**
- Choose a unique name for your bucket (e.g., `devops-qr-code-bucket`)
- Disable **Block Public Access** (only if you want the QR codes to be publicly accessible)

📌 **Example bucket name:** `your-unique-bucket-name`

---

### 2. Enable Bucket Policy

To allow public read access to the generated QR codes, configure a bucket policy.

📄 **Example Bucket Policy:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-unique-bucket-name/qr_codes/*"
    }
  ]
}

```

---

## 🏃‍♂️ Running Locally with Docker

Follow these steps to run the application locally using Docker:

### 1. Clone the Repository

```bash
git clone <repository_url>
cd DevOps-QR-Generator-Docker
```

### 2. Set Up AWS Credentials

Ensure your AWS credentials are configured on your local machine using the AWS CLI:

```bash
aws configure
```

### 3. Update the `.env` File

In the root of the project, create a `.env` file and add the following variables:  
(You can also use `.env.example` as a reference.)

```env
AWS_ACCESS_KEY=your-aws-access-key
AWS_SECRET_KEY=your-aws-secret-key
BUCKET_NAME=your-unique-bucket-name
```

### 4. Build and Run the Docker Containers

Use Docker Compose to build and start the application:

```bash
docker-compose up --build
```

🔧 **This will:**

- Build the Docker images for the Back-End API and Front-End
- Start the services and map the appropriate ports

🚀 **Back-End API** will be running at:  
`http://localhost:8000`

### 5. Stop the Services

To stop all running containers:

```bash
docker-compose down
```