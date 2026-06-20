\# Jenkins Installation



\## Install Jenkins



Create Script



```bash

vi jen.sh

```



Paste installation commands and save.



Run Script



```bash

sh jen.sh

```



Verify Jenkins Service



```bash

systemctl status jenkins

```



Access Jenkins



```text

http://PUBLIC-IP:8080

```



Get Jenkins Password



```bash

cat /var/lib/jenkins/secrets/initialAdminPassword

```



Install Suggested Plugins and Complete Setup.

