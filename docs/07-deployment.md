\# Application Deployment



\## Create Deployment Playbook



```bash

vi deploy.yml

```



\## Deploy WAR File



```bash

ansible-playbook deploy.yml

```



\## Jenkins Integration



Install Jenkins Plugins:



\- Ansible Plugin

\- Maven Integration Plugin



Configure:



\- Ansible Tool

\- Jenkins Credentials

\- Inventory File



\## Build Pipeline



Click:



```text

Build Now

```



\## Deployment Flow



Developer Push Code

↓

GitHub

↓

Jenkins Pipeline

↓

Build and Test

↓

Generate WAR

↓

Ansible Playbook

↓

Tomcat Server 1

Tomcat Server 2

↓

Application Available

