#!/bin/bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git unzip fontconfig openjdk-17-jre

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker admin
sudo usermod -aG docker jenkins 2>/dev/null || true

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins

sudo apt install -y nginx
sudo systemctl enable docker jenkins nginx
sudo systemctl start docker jenkins nginx

echo "Senha inicial do Jenkins:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword