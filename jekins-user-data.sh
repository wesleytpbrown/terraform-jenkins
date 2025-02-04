#!/bin/bash
# Update the package list
sudo apt update -y
sudo apt upgrade -y

# Install Java (required for Jenkins)
sudo apt install -y fontconfig openjdk-17-jre

# Add Jenkins repository and key
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key 
 sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
 echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" 
 sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list again and install Jenkins
sudo apt update -y
sudo apt install -y jenkins

# Start and enable Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Open port 8080 for Jenkins using UFW (Ubuntu firewall)
sudo ufw allow 8080/tcp
sudo ufw --force enable
