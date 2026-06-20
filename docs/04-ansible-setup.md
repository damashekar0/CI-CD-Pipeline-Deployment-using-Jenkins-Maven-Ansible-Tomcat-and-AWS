\# Ansible Setup



\## Install Ansible



```bash

sudo dnf install ansible -y

```



Install Python



```bash

sudo dnf install python3 python3-pip -y

```



Verify Installation



```bash

ansible --version

```



\## Configure Inventory



```bash

vi /etc/ansible/hosts

```



Example



```ini

\[tomcat]

172.31.xx.xx

172.31.xx.xx

```



\## Test Connectivity



```bash

ansible all -m ping

```

