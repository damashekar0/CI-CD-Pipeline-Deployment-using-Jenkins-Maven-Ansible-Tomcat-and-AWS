\# 🚀 AWS CI/CD Pipeline using Jenkins, Maven, Ansible and Tomcat

\# 📖 Project Overview



This project demonstrates a complete CI/CD pipeline using Jenkins, Maven, Ansible, Apache Tomcat, and AWS EC2 instances.



The pipeline automates source code checkout, build, testing, artifact generation, and deployment to Tomcat application servers using Ansible.



\#Architecture:

&#x20;                   +------------------+


&#x20;                   |    Developers    |

&#x20;                   +------------------+

&#x20;                             |

&#x20;                             | Push Code

&#x20;                             v

&#x20;                   +------------------+

&#x20;                   |      GitHub      |

&#x20;                   +------------------+

&#x20;                             |

&#x20;                             | Checkout

&#x20;                             v

&#x20;       +------------------------------------------------+

&#x20;       |          Jenkins + Ansible Server              |

&#x20;       +------------------------------------------------+

&#x20;       |                                                |

&#x20;       |  Stage 1 : Checkout Source Code                |

&#x20;       |  Stage 2 : Build (mvn compile)                 |

&#x20;       |  Stage 3 : Test (mvn test)                     |

&#x20;       |  Stage 4 : Generate Artifact (.war)            |

&#x20;       |                                                |

&#x20;       +------------------------------------------------+

&#x20;                             |

&#x20;                             | Ansible Playbook

&#x20;                             v

&#x20;                +----------------------------+

&#x20;                |      Deploy Artifact       |

&#x20;                +----------------------------+

&#x20;                             |

&#x20;               +-------------+-------------+

&#x20;               |                           |

&#x20;               v                           v

&#x20;     +------------------+      +------------------+

&#x20;     |  Tomcat Server 1 |      |  Tomcat Server 2 |

&#x20;     +------------------+      +------------------+

&#x20;     | Java + Tomcat    |      | Java + Tomcat    |

&#x20;     | Application WAR  |      | Application WAR  |

&#x20;     +------------------+      +------------------+

&#x20;               |                           |

&#x20;               +-------------+-------------+

&#x20;                             |

&#x20;                             v

&#x20;                   +------------------+

&#x20;                   |     End Users    |

&#x20;                   +------------------+


![image].(https://github.com/damashekar0/CI-CD-Pipeline-Deployment-using-Jenkins-Maven-Ansible-Tomcat-and-AWS/blob/d2cae0589070b8d0fcc225698e4d4a9a9b59eef9/screenshots/AWS%20CICD%20Pipeline%20Using%20Jenkins%2C%20Maven%2C%20Ansible%20project.png).


-Launch EC2 instance t2.micro = Jenkins + Ansible 
-Launch EC2 instance 2 t3.micro = worker nodes where we have application running with tomcat. tomcat1 and tomcat2

#### Tomcat Security Group



\- SSH (22) → Jenkins Server Security Group

\- Custom TCP (8080) → Anywhere IPv4 (0.0.0.0/0)


 !\[image alt].(https://github.com/damashekar0/CI-CD-Pipeline-Deployment-using-Jenkins-Maven-Ansible-Tomcat-and-AWS/blob/d2cae0589070b8d0fcc225698e4d4a9a9b59eef9/screenshots/ec2-instances.png).

## Step 1 : 🔧 Jenkins Installation on Ansible Server



Jenkins was installed on the same AWS EC2 instance that was used as the Ansible Control Node (Jensible Server). A shell script was created to automate the installation of Git, Maven, Java 21, and Jenkins.



\### Installation Script



Create a file named `jen.sh`:



```bash

\#!/bin/bash



\# STEP-1: Install Git and Maven

yum install git maven -y



\# STEP-2: Add Jenkins Repository

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key



\# STEP-3: Install Java 21 and Jenkins

yum install java-21-amazon-corretto -y

yum install jenkins -y



\# Increase /tmp size

mount -o remount,size=2G /tmp



\# STEP-4: Start Jenkins Service

systemctl start jenkins.service

systemctl status jenkins.service



\# STEP-5: Enable Jenkins at Boot

chkconfig jenkins on

```



\### Execute the Script



```bash

chmod +x jen.sh

sh jen.sh

```



\### Verify Jenkins Service



```bash

systemctl status jenkins

```



\### Access Jenkins



Open the browser:



```text

http://<JENKINS-PUBLIC-IP>:8080

```



Retrieve the initial admin password:



```bash

cat /var/lib/jenkins/secrets/initialAdminPassword

```



\### Components Installed



\* Git

\* Maven

\* Java 21 (Amazon Corretto)

\* Jenkins


## Step 2 : 🔐 Configure Password Authentication and SSH Connectivity



To enable Ansible communication between the Jenkins/Ansible server and Tomcat worker nodes, root password authentication and SSH access were configured on all servers.



\### Step 1: Set Root Password



Switch to root user and create a password:



```bash

sudo -i

passwd root

```



\### Step 2: Configure SSH



Edit SSH configuration:



```bash

vi /etc/ssh/sshd\_config

```



Update the following parameters:



```text

PermitRootLogin yes

PasswordAuthentication yes

```



\### Step 3: Restart SSH Service



```bash

systemctl restart sshd

```



\### Step 4: Verify Configuration



```bash

grep -E "PermitRootLogin|PasswordAuthentication" /etc/ssh/sshd\_config

```



Expected Output:



```text

PermitRootLogin yes

PasswordAuthentication yes

```

!\[image alt].(https://github.com/damashekar0/CI-CD-Pipeline-Deployment-using-Jenkins-Maven-Ansible-Tomcat-and-AWS/blob/d2cae0589070b8d0fcc225698e4d4a9a9b59eef9/screenshots/ssh-password-authentication-config.png).




\### Step 5: Check Private IP Address



```bash

hostname -i

```



Example:



```text

Jensible Server : 172.31.11.14

Tomcat Server 1 : 172.31.41.16

Tomcat Server 2 : 172.31.35.255

```



\### Step 6: Test SSH Connectivity



From the Jenkins/Ansible server:



```bash

ssh root@172.31.41.16

```



```bash

ssh root@172.31.35.255

```



Enter the root password configured on each Tomcat server.



\### Step 7: Generate SSH Key



On Jenkins/Ansible Server:



```bash

ssh-keygen

```



Press Enter for all prompts.



\### Step 8: Copy SSH Key to Worker Nodes



```bash

ssh-copy-id root@172.31.41.16

```



```bash

ssh-copy-id root@172.31.35.255

```



Enter the root password once.



\### Step 9: Verify Passwordless Authentication



```bash

ssh root@172.31.41.16

```



```bash

ssh root@172.31.35.255

```



The connection should be established without prompting for a password.



Successfully configured SSH password authentication and passwordless SSH communication between the Jenkins/Ansible server and Tomcat worker nodes, enabling automated deployments through Ansible playbooks.





## Step 3: ⚙️ Install and Configure Ansible



Ansible was installed on the Jenkins/Ansible server to automate configuration management and application deployment across multiple Tomcat servers.



\### Install Ansible



```bash

sudo dnf install ansible -y

sudo dnf install python3 python3-pip -y

```



\### Verify Installation



```bash

ansible --version

python3 --version

```



\### Configure Inventory File



Edit the Ansible inventory file:



```bash

vi /etc/ansible/hosts

```



Add worker node IP addresses:



```ini

\[tomcat]

172.31.41.16

172.31.35.255

```



\### Test Connectivity



Verify communication with all managed nodes:



```bash

ansible all -m ping

```



Expected Output:



```text

172.31.41.16 | SUCCESS

172.31.35.255 | SUCCESS

```



\### Verify Remote Access



```bash

ssh root@172.31.41.16

ssh root@172.31.35.255

```



\### Outcome



Successfully installed and configured Ansible on the Jenkins server. Verified connectivity to Tomcat worker nodes and prepared the environment for automated application deployment using Ansible playbooks.




# Step 4: Install and Configure Apache Tomcat using Ansible



After installing Ansible on the Jenkins/Ansible server, create a playbook to automate Apache Tomcat installation on all worker nodes.



\## Create Tomcat Playbook|

vi tomcat.yml



```yaml

\---

\- name: Setup Tomcat

&#x20; hosts: all

&#x20; become: yes



&#x20; tasks:

&#x20;   - name: Download Tomcat

&#x20;     get\_url:

&#x20;       url: "https://downloads.apache.org/tomcat/tomcat-11/v11.0.22/bin/apache-tomcat-11.0.22.tar.gz"

&#x20;       dest: "/root/"



&#x20;   - name: Extract Tomcat

&#x20;     command: tar -zxvf apache-tomcat-11.0.22.tar.gz



&#x20;   - name: Rename Tomcat Directory

&#x20;     command: mv apache-tomcat-11.0.22 tomcat



&#x20;   - name: Install Java 17

&#x20;     yum:

&#x20;       name: java-17-amazon-corretto

&#x20;       state: present



&#x20;   - name: Configure tomcat-users.xml

&#x20;     template:

&#x20;       src: tomcat-users.xml

&#x20;       dest: /root/tomcat/conf/tomcat-users.xml



&#x20;   - name: Configure context.xml

&#x20;     template:

&#x20;       src: context.xml

&#x20;       dest: /root/tomcat/webapps/manager/META-INF/context.xml



&#x20;   - name: Create Tomcat Service

&#x20;     copy:

&#x20;       dest: /etc/systemd/system/tomcat.service

&#x20;       content: |

&#x20;         \[Unit]

&#x20;         Description=Apache Tomcat Server

&#x20;         After=network.target



&#x20;         \[Service]

&#x20;         User=root

&#x20;         Group=root

&#x20;         Type=forking

&#x20;         Environment="JAVA\_HOME=/usr/lib/jvm/jre"

&#x20;         Environment="CATALINA\_HOME=/root/tomcat"

&#x20;         ExecStart=/root/tomcat/bin/startup.sh

&#x20;         ExecStop=/root/tomcat/bin/shutdown.sh

&#x20;         Restart=on-failure



&#x20;         \[Install]

&#x20;         WantedBy=multi-user.target



&#x20;   - name: Reload Systemd

&#x20;     systemd:

&#x20;       daemon\_reload: yes



&#x20;   - name: Start Tomcat Service

&#x20;     service:

&#x20;       name: tomcat

&#x20;       state: started

&#x20;       enabled: yes

```


!\[image alt].(https://github.com/damashekar0/CI-CD-Pipeline-Deployment-using-Jenkins-Maven-Ansible-Tomcat-and-AWS/blob/d2cae0589070b8d0fcc225698e4d4a9a9b59eef9/screenshots/setup-tomcat.png).





\## Create Tomcat User Configuration



Create a file named `tomcat-users.xml`



```xml

<?xml version="1.0" encoding="UTF-8"?>

<tomcat-users xmlns="http://tomcat.apache.org/xml"

&#x20;             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

&#x20;             xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"

&#x20;             version="1.0">



&#x20; <role rolename="manager-gui"/>

&#x20; <role rolename="manager-script"/>



&#x20; <user username="tomcat"

&#x20;       password="root123456"

&#x20;       roles="manager-gui,manager-script"/>



</tomcat-users>

```



\## Create Context Configuration



Create a file named `context.xml`



```xml

<?xml version="1.0" encoding="UTF-8"?>

<Context antiResourceLocking="false" privileged="true">



&#x20; <CookieProcessor

&#x20;     className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"

&#x20;     sameSiteCookies="strict" />



&#x20; <Manager sessionAttributeValueClassNameFilter="java\\.lang\\.(?:Boolean|Integer|Long|Number|String)|org\\.apache\\.catalina\\.filters\\.CsrfPreventionFilter\\$LruCache(?:\\$1)?|java\\.util\\.(?:Linked)?HashMap"/>



</Context>

```



\## Execute the Playbook



Run the following command from the Jenkins/Ansible server:



```bash

ansible-playbook tomcat.yml

```



\## Verification



Check Tomcat status:



```bash

systemctl status tomcat

```



Access Tomcat Manager:



```text

http://<Tomcat-Server-IP>:8080

```



Username:

tomcat



Password:

root123456



!\[image alt].(https://github.com/damashekar0/CI-CD-Pipeline-Deployment-using-Jenkins-Maven-Ansible-Tomcat-and-AWS/blob/d2cae0589070b8d0fcc225698e4d4a9a9b59eef9/screenshots/tomcat%20server.png).


# Step 5: Integrate Ansible with Jenkins for Automated Deployment



After configuring Jenkins, Ansible, and Tomcat servers, integrate Ansible into the Jenkins Pipeline to automate application deployment.



\---



\## Install Required Jenkins Plugin



Navigate to:



```text

Manage Jenkins → Plugins

```



Install:



\* Ansible Plugin



Restart Jenkins after installation.



\---



\## Configure Ansible Tool in Jenkins



Navigate to:



```text

Manage Jenkins → Tools

```



Add Ansible installation:



```text

Name : ansible

Path : /bin

```



Save the configuration.



\---



\## Configure Jenkins Credentials



\### Username and Password



Navigate to:



```text

Manage Jenkins → Credentials

```



Add Credentials:



```text

Kind       : Username with password

Username   : root

Password   : root123456

ID         : linuxcreds

```



\---



Kind       : SSH Username with Private Key

Username   : ec2-user

ID         : linuxcreds

Private Key: Enter directly

```



\## Create Jenkins Pipeline Project



Navigate to:



```text

Jenkins Dashboard → New Item

```



Enter:



```text

Project Name : ansible-project

Project Type : Pipeline

```



Click \*\*OK\*\*.

!\[image alt].(https://github.com/damashekar0/CI-CD-Pipeline-Deployment-using-Jenkins-Maven-Ansible-Tomcat-and-AWS/blob/d2cae0589070b8d0fcc225698e4d4a9a9b59eef9/screenshots/jenkins.png).




\---



\## Configure Pipeline Script



Navigate to:



```text

ansible-project → Configure → Pipeline

```



Paste the following Jenkins Pipeline:



```groovy

pipeline{

&#x20;   agent any



&#x20;   stages{



&#x20;       stage('Checkout') {

&#x20;           steps{

&#x20;               git 'https://github.com/damashekar0/java-project-maven-new.git'

&#x20;           }

&#x20;       }



&#x20;       stage('Build') {

&#x20;           steps {

&#x20;               sh 'mvn compile'

&#x20;           }

&#x20;       }



&#x20;       stage('Test') {

&#x20;           steps {

&#x20;               sh 'mvn test'

&#x20;           }

&#x20;       }



&#x20;       stage('Artifacts') {

&#x20;           steps {

&#x20;               sh 'mvn clean package'

&#x20;           }

&#x20;       }



&#x20;       stage('Deploy') {

&#x20;           steps {

&#x20;               ansiblePlaybook(

&#x20;                   credentialsId: 'linuxcreds',

&#x20;                   disableHostKeyChecking: true,

&#x20;                   installation: 'ansible',

&#x20;                   inventory: '/etc/ansible/hosts',

&#x20;                   playbook: '/etc/ansible/deploy.yml',

&#x20;                   vaultTmpPath: ''

&#x20;               )

&#x20;           }

&#x20;       }

&#x20;   }

}

```



Save the configuration.



\---



\## Create Deployment Playbook



Login to Jenkins/Ansible Server:



```bash

cd /etc/ansible/

ls

```



Create deployment playbook:



```bash

vi deploy.yml

```



Add the following content:



```yaml

\---

\- name: Deploy war to tomcat servers

&#x20; hosts: all



&#x20; tasks:

&#x20;   - name: Copy WAR File

&#x20;     copy:

&#x20;       src: /var/lib/jenkins/workspace/project/target/myapp.war

&#x20;       dest: /root/tomcat/webapps/

```



Save and exit.



\---



\## Test Deployment Manually



Before integrating with Jenkins, verify the playbook manually:



```bash

ansible-playbook deploy.yml

```



Expected Result:



```text

PLAY RECAP



tomcat1 : ok=1 changed=1 failed=0

tomcat2 : ok=1 changed=1 failed=0

```



\---



\## Jenkins Deployment Workflow



```text

GitHub Repository

&#x20;       │

&#x20;       ▼

Checkout Source Code

&#x20;       │

&#x20;       ▼

Maven Compile

&#x20;       │

&#x20;       ▼

Maven Test

&#x20;       │

&#x20;       ▼

Generate WAR Artifact

&#x20;       │

&#x20;       ▼

Ansible Playbook

&#x20;       │

&#x20;       ├──────────► Tomcat Server 1

&#x20;       │

&#x20;       └──────────► Tomcat Server 2

```



\---



\## Build and Deploy



Navigate to:



```text

ansible-project → Build Now

```



Jenkins will automatically:



1\. Pull source code from GitHub.

2\. Compile the application using Maven.

3\. Execute test cases.

4\. Generate WAR artifact.

5\. Trigger Ansible deployment.

6\. Copy WAR file to all Tomcat servers.

7\. Deploy the application automatically.

!\[image alt].(https://github.com/damashekar0/CI-CD-Pipeline-Deployment-using-Jenkins-Maven-Ansible-Tomcat-and-AWS/blob/d2cae0589070b8d0fcc225698e4d4a9a9b59eef9/screenshots/jenkin%20deployment.png).




\---



\## Outcome



\* Jenkins Pipeline successfully integrated with Ansible.

\* Maven automatically builds the application.

\* WAR artifacts are generated automatically.

\* Ansible deploys the application to multiple Tomcat servers.

\* Fully automated CI/CD pipeline implemented on AWS using Jenkins, Maven, Ansible, and Apache Tomcat.




## Step 6: Verify Application Deployment



After the Jenkins Pipeline completes successfully, Ansible copies the WAR file to all Tomcat servers.



\### Verify WAR Deployment



Login to Tomcat servers:



```bash

ssh root@<tomcat-server-ip>

```



Check the deployed WAR file:



```bash

ls /root/tomcat/webapps/

```



Expected Output:



```text

myapp.war

myapp/

```

!\[image alt].(https://github.com/damashekar0/CI-CD-Pipeline-Deployment-using-Jenkins-Maven-Ansible-Tomcat-and-AWS/blob/d2cae0589070b8d0fcc225698e4d4a9a9b59eef9/screenshots/tomcat%20web%20application.png).



\### Check Tomcat Service Status



```bash

systemctl status tomcat

```



Expected Output:



```text

active (running)

```



\### Access Application



Open the application in your browser:



```text

http://<Tomcat1-Public-IP>:8080/myapp

```



Example:



```text

http://13.xx.xx.xx:8080/myapp

```



Tomcat Server 2:



```text

http://<Tomcat2-Public-IP>:8080/myapp

```



Example:



```text

http://15.xx.xx.xx:8080/myapp

```



\### Verify Tomcat Manager



```text

http://<Tomcat-Public-IP>:8080/manager/html

```



Login Credentials:



```text

Username : tomcat

Password : root123456

```

## Output:

!\[image alt].(https://github.com/damashekar0/CI-CD-Pipeline-Deployment-using-Jenkins-Maven-Ansible-Tomcat-and-AWS/blob/d2cae0589070b8d0fcc225698e4d4a9a9b59eef9/screenshots/output%20.png).



## Technologies Used

* AWS EC2
* Linux
* Git
* GitHub
* Jenkins
* Maven
* Ansible
* Apache Tomcat
* Java
* SSH
* Project Outcome



Successfully implemented a CI/CD pipeline that automates application build, testing, packaging, and deployment using Jenkins, Maven, Ansible, and Apache Tomcat on AWS. The solution reduced manual deployment effort and enabled consistent deployment across multiple application servers.



