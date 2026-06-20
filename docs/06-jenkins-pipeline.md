# Jenkins Pipeline



## Pipeline Stages



### Checkout



Downloads source code from GitHub.



### Build



Compiles source code.



```bash

mvn compile

```



### Test



Runs application test cases.



```bash

mvn test

```



### Artifacts



Generates WAR package.



```bash

mvn clean package

```



### Deploy



Runs Ansible playbook to deploy WAR file.



## Workflow



GitHub

↓

Checkout

↓

Build

↓

Test

↓

Generate WAR

↓

Ansible Deploy

↓

Tomcat Servers

