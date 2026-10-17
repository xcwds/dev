#!/bin/sh
# Install Docker on Ubuntu
set -e

echo "🚀 Starting official Docker Engine installation..."

## Update package index, install prereqs
sudo apt update
sudo apt install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

## Add Docker repository to APT sources
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## Install Docker packages
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker ${USER}
su - ${USER}

sudo systemctl status docker
docker run --rm hello-world

# Enable Docker to start on boot
sudo systemctl enable docker
sudo systemctl start docker

# Set up non-root user permissions (adds the current user)
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi
sudo usermod -aG docker $USER

echo "✅ Docker installation complete!"
echo "⚠️ IMPORTANT: Please run 'newgrp docker' or log out and back in to apply non-root user permissions."
echo "🐳 Afterwards, you can verify it works by running: docker run hello-world"
