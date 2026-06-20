#!/bin/bash

# Install Ansible

sudo dnf install ansible -y

# Install Python

sudo dnf install python3 python3-pip -y

# Verify Installation

ansible --version