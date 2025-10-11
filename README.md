# DevOps QR Code Generator

This project is a part of the **DevOps Capstone Project**, designed to generate QR codes for provided URLs. The solution consists of two main components:

- **Front-End**: A web application built with **NextJS** for user interaction.
- **Back-End API**: A **Python FastAPI**-based server that accepts URLs, generates corresponding QR codes, and stores them in **AWS S3** for cloud storage.

---

## **Project Overview**

The **DevOps QR Code Generator** is designed to demonstrate several key DevOps principles, including containerization, cloud infrastructure, CI/CD pipelines, and monitoring. The application integrates AWS services for scalable cloud storage and leverages modern web development technologies for the front-end.

---

## **Architecture**

The architecture of the QR Code Generator includes:

- **Next.js Front-End**: A React-based web application where users input URLs to generate corresponding QR codes. The front-end communicates with the FastAPI back-end to process the URLs and generate the QR codes.
  
- **FastAPI Back-End**: A Python-based API that accepts URL requests, generates QR codes, and uploads the images to AWS S3 for storage.
  
- **AWS S3**: Used to store the generated QR code images. The app interacts with AWS services to provide persistent and scalable storage.

---

## **Prerequisites**

Before running this application locally, make sure the following tools are installed:

- **Python 3.x** for the FastAPI back-end
- **Node.js** and **npm** for the Next.js front-end
- **AWS CLI** for AWS interaction (used to set up S3)
- **Docker** (Optional for containerization)
- **Git** for cloning the repository

---

## **AWS S3 Setup**

To store the generated QR codes, you will need to set up an **S3 Bucket**. Follow these steps to configure your AWS S3 bucket:

### Steps to Set Up the S3 Bucket:

1. **Create an S3 Bucket**:
   - Go to the [S3 Console](https://s3.console.aws.amazon.com/s3/home) and create a new bucket.
   - Choose a unique name for your bucket (e.g., `devops-qr-code-bucket`).
   - Disable **Block Public Access** (if you want the QR codes to be publicly accessible).
   - Example bucket name: `your-unique-bucket-name`.

2. **Enable Bucket Policy**:
   - To allow public read access to the generated QR codes, configure a bucket policy.
   
   Example **Bucket Policy** to allow public read access:
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

## Running locally

### API

The API code exists in the `api` directory. You can run the API server locally:

1. Clone this repo.
2. Make sure you are in the `api` directory.
3. Create a virtual environment by running the following command:

    ```bash
    python -m venv .venv
    ```

4. Activate the virtual environment:

    - For **Linux/MacOS**:

      ```bash
      source .venv/bin/activate
      ```

    - For **Windows**:

      ```bash
      .venv\Scripts\activate
      ```

5. Install the required packages:

    ```bash
    pip install -r requirements.txt
    ```

6. Create a `.env` file and add your AWS Access Key, AWS Secret Key, and S3 Bucket Name (refer to `.env.example` for the format).
7. Update the **BUCKET_NAME** to your S3 bucket name in `main.py`.
8. Run the API server:

    ```bash
    uvicorn main:app --reload
    ```

Your **API Server** should be running on `http://localhost:8000`.

### Front-End

The front-end code exists in the `front-end-nextjs` directory. You can run the front-end server locally:

1. Clone this repo.
2. Make sure you are in the `front-end-nextjs` directory.
3. Install the required dependencies:

    ```bash
    npm install
    ```

4. Run the Next.js development server:

    ```bash
    npm run dev
    ```

Your **Front-End Server** should be running on `http://localhost:3000`.

---

## Goal

The goal is to get hands-on experience with DevOps practices like **Containerization**, **CI/CD**, and **Monitoring**.

For more details, refer to the **Capstone Project**.
