\# AWS Infrastructure Setup



\## EC2 Instances



\### Jenkins + Ansible Server



\- Instance Type: t2.micro

\- Operating System: Amazon Linux 2023



Purpose:

\- Jenkins Server

\- Ansible Control Node



\### Tomcat Server 1



\- Instance Type: t3.micro



Purpose:

\- Application Deployment



\### Tomcat Server 2



\- Instance Type: t3.micro



Purpose:

\- Application Deployment



\## Security Groups



\### Jenkins Server



| Port | Purpose |

|--------|---------|

| 22 | SSH |

| 8080 | Jenkins |



\### Tomcat Servers



| Port | Purpose |

|--------|---------|

| 22 | SSH |

| 8080 | Tomcat |

