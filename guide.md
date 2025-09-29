create .env
create docker-compose file
if any issues check .env of both folders

# Navigate to backend folder
cd ~/DevOps-QR-Generator/QR-Generator/backend-api

# Build image
docker build -t qr-generator-backend:local .

# Run container with .env file
docker run -it --rm \
  -p 8000:80 \
  --env-file .env \
  --name qr-backend \
  qr-generator-backend:local


# Navigate to frontend folder
cd ~/DevOps-QR-Generator/QR-Generator/front-end-nextjs

# Build image
docker build -t qr-generator-frontend:local .

# Run container, pointing it to backend
docker run -it --rm \
  -p 3000:3000 \
  -e NEXT_PUBLIC_BACKEND_URL=http://localhost:8000 \
  --name qr-frontend \
  qr-generator-frontend:local


cd ~/DevOps-QR-Generator

# Build and run containers
docker-compose up --build

docker-compose down


cd Infra/
terraform init
terraform apply -var-file=terraform.tfvars
