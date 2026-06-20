# Ansible Configuration



This folder contains all Ansible configuration files used for automating Tomcat installation and application deployment.



\## Files



### hosts



Inventory file containing worker node IP addresses.



### tomcat.yml



Playbook to install and configure Apache Tomcat on worker nodes.



### deploy.yml



Playbook to deploy WAR artifacts from Jenkins to Tomcat servers.



### tomcat-users.xml



Tomcat Manager user configuration.



### context.xml



Tomcat Manager access configuration.

