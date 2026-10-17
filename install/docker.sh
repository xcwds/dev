#!/bin/bash
set -e

echo "🚀 Starting official Docker Engine installation..."

# 1. Update package list and install prerequisites
sudo apt update && sudo apt install -y ca-certificates curl

# 2. Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://docker.com -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 3. Add the Docker repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://docker.com $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 4. Install Docker packages
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 5. Enable Docker to start on boot
sudo systemctl enable docker
sudo systemctl start docker

# 6. Set up non-root user permissions (adds the current user)
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi
sudo usermod -aG docker $USER

echo "✅ Docker installation complete!"
echo "⚠️ IMPORTANT: Please run 'newgrp docker' or log out and back in to apply non-root user permissions."
echo "🐳 Afterwards, you can verify it works by running: docker run hello-world"
