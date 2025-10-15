#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo apt update -y
sudo apt install -y zip unzip curl wget gnupg lsb-release ca-certificates apt-transport-https software-properties-common

echo "📦 Installing Java (OpenJDK 17)..."
sudo apt install -y openjdk-17-jdk
java -version

echo "☁️ Installing Jenkins..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /etc/apt/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install -y jenkins

echo "🚀 Starting and enabling Jenkins..."
sudo systemctl daemon-reexec  # In case PID 1 was upgraded (common in cloud images)
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "🐳 Installing Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

echo "👤 Adding 'ubuntu' and 'jenkins' users to docker group..."
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins

echo "🧰 Installing AWS CLI v2..."
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install --update
rm -rf awscliv2.zip aws

echo "📦 Installing kubectl (latest stable)..."
KUBECTL_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

echo "🌍 Installing Terraform..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
sudo apt update -y
sudo apt install -y terraform

echo "🧱 Installing eksctl..."
curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" -o eksctl.tar.gz
tar -xzf eksctl.tar.gz
sudo mv eksctl /usr/local/bin/
rm -f eksctl.tar.gz

echo "🔁 Reboot is recommended to apply group changes (docker group access for Jenkins/Ubuntu)."
echo "✅ Installation Complete!"

# ---------------------
# ✅ Final Verification
# ---------------------
echo ""
echo "==================== 📋 VERIFYING INSTALLATIONS ===================="

echo "🔎 Jenkins status:"
sudo systemctl status jenkins | grep Active

echo "🔎 Java version:"
java -version

echo "🔎 Docker version:"
docker --version

echo "🔎 AWS CLI version:"
aws --version

echo "🔎 kubectl version:"
kubectl version --client

echo "🔎 terraform version:"
terraform -version

echo "🔎 eksctl version:"
eksctl version

echo "🔎 Group memberships:"
echo " - ubuntu user: $(groups ubuntu)"
echo " - jenkins user: $(groups jenkins)"

echo "===================================================================="
echo "✅ All tools installed and verified."
