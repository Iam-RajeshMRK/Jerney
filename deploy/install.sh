#!/bin/bash

set -e

echo "Updating packages..."
sudo apt update -y

echo "Installing required packages..."
sudo apt install -y curl unzip wget gnupg software-properties-common apt-transport-https ca-certificates

############################################
# Install Docker
############################################
echo "Installing Docker..."
sudo apt install -y docker.io

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER

############################################
# Install Docker Compose
############################################

#Download the latest release:
mkdir -p ~/.docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v5.1.2/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose

#Make it executable:
chmod +x ~/.docker/cli-plugins/docker-compose

############################################
# Install AWS CLI v2
############################################
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip -o awscliv2.zip

sudo ./aws/install

############################################
# Install Terraform
############################################
echo "Installing Terraform..."

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update -y
sudo apt install -y terraform

############################################
# Install kubectl
############################################
echo "Installing kubectl..."

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin

############################################
# Verify installations
############################################
echo ""
echo "===== Installed Versions ====="

terraform -version
docker --version
aws --version
kubectl version --client
docker compose version

echo ""
echo "Installation completed successfully."
echo "Logout and login again to use Docker without sudo."
