#!/bin/bash
# Install Docker on Amazon Linux 2023

set -e

echo "Installing Docker..."

# Update system packages
sudo dnf update -y

# Install Docker
sudo dnf install -y docker

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to docker group
sudo usermod -aG docker ec2-user

# Verify installation
docker --version

echo "Docker installed successfully"
echo "Note: You may need to log out and back in for group changes to take effect"
