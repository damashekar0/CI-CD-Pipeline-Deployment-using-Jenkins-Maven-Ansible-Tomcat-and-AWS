#!/bin/bash

# Generate SSH Key

ssh-keygen -t rsa

# Copy Key to Worker Nodes

ssh-copy-id root@TOMCAT1_PRIVATE_IP

ssh-copy-id root@TOMCAT2_PRIVATE_IP