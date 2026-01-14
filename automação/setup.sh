#!/bin/bash

if [ ! -f /swapfile ]; then
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
else
    echo "--- Swap existente"
fi

sudo apt update
sudo apt install -y curl git unzip fontconfig

wget https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.deb
sudo apt install -y ./amazon-corretto-21-x64-linux-jdk.deb
rm amazon-corretto-21-x64-linux-jdk.deb # Limpa o arquivo instalador

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker admin
sudo usermod -aG docker jenkins 2>/dev/null || true
rm get-docker.sh

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins

sudo apt install -y nginx

echo "server {
    listen 81;
    server_name localhost;

    access_log off;
    allow 127.0.0.1;
    deny all;

    location /nginx_status {
        stub_status;
    }
}" | sudo tee /etc/nginx/conf.d/status.conf

sudo systemctl enable docker jenkins nginx
sudo systemctl restart docker jenkins nginx

echo "Senha inicial do Jenkins:"
sleep 10
sudo cat /var/lib/jenkins/secrets/initialAdminPassword