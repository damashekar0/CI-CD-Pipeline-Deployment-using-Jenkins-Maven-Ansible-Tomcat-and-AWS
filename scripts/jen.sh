#!/bin/bash

# Install Git and Maven
yum install git maven -y

# Jenkins Repository
wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Java
yum install java-21-amazon-corretto -y

# Install Jenkins
yum install jenkins -y

# Start Jenkins
systemctl start jenkins
systemctl enable jenkins

# Check Status
systemctl status jenkins