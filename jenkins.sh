#!/bin/bash

# Update the system
echo "Updating system..."
sudo yum update -y

# Install Java (Jenkins requires Java to run, so we'll install OpenJDK 17)
echo "Installing OpenJDK 17..." 
sudo yum install -y java-17-openjdk-devel 

# Verify Java installation
echo "Verifying Java installation..."
java -version

# Install wget to fetch Jenkins repository
echo "Installing wget..."
sudo yum install -y wget

# Add Jenkins repository to your system
echo "Adding Jenkins repository..."
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo

# Import the Jenkins repository GPG key
echo "Importing Jenkins GPG key..."
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

# Install Jenkins
echo "Installing Jenkins..."
sudo yum install -y jenkins

# Enable and start Jenkins service
echo "Starting and enabling Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check Jenkins service status
echo "Checking Jenkins service status..."
sudo systemctl status jenkins

# Open port 8080 on the firewall to allow Jenkins web access
# EC2 typically uses AWS Security Groups, but if firewalld is enabled on Amazon Linux 2, we open port 8080
if command -v firewall-cmd &> /dev/null
then
    echo "Opening port 8080 in the firewall..."
    sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
    sudo firewall-cmd --reload
else
    echo "firewalld is not installed or not running. Skipping firewall configuration."
fi

# Display Jenkins unlock key (you need this to unlock Jenkins in the browser)
echo "Jenkins installation is complete. You can unlock Jenkins using the following key:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Output URL to access Jenkins web interface
echo "Jenkins is up and running. Access it via http://<your_server_public_ip>:8080"
