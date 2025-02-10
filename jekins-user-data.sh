
#!/bin/bash

# Update and install required packages
sudo apt update -y
sudo apt install -y openjdk-17-jdk wget gnupg

# Add Jenkins repository and import the GPG key
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key 
sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" 
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package lists and install Jenkins
sudo apt update -y
sudo apt install -y jenkins

# Start and enable Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Open firewall ports for Jenkins (if UFW is enabled)
sudo ufw allow 22
sudo ufw allow 8080
sudo ufw --force enable

# Print initial Jenkins admin password
echo "Jenkins installed. Retrieve admin password using:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword" 
tee /home/ubuntu/jenkins-setup-info.txt
