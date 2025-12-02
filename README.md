# Berkeley Project

## Document Info
 - Project Name: Berkeley Project
 - Author: Vidhush R
 - Date: 02-12-2025

## Summary

Project requirement is to build a application to track the number of users that visit the webpage. The webpage should be built as a microservice hosted in Kubernetes cluster in AWS Cloud. Application data layer is hosted in Redis DB. All of the Infra build for this project are documented as IAC code in terraform.  

## Technologies Used in the project:
1. AWS 
2. Terraform.
3. Gitlab CI/CD Pipeline.
4. Python.

## High Level Architecture
![alt text](https://github.com/vidhush07/berkeley_project/blob/88b73870c2ec322c41170f6ebaba60c117577baa/docs/Images/High_level_arch_diagram.png)

### User Flow
    1. Users access the website by entering the URL in the browser. DNS resolves to the IP address of the nearest CloudFront edge location.
    2. Cloud front forwards the request to ALB.
    3. ALB distributes the request based on the backend target configured. NLB is configured as the backend target.
    4. NLB based on the load balancing rules sends the traffic to the Kubernetes Service LoadBalancer and Kubernetes service loadbalancer sends the traffic to the Pod.
    5. Application running inside the pod connects to the AWS MemoryDB (redis) to increase the count of the number of visitors.

## Detailed Design Diagram
All the resources are built in AWS Singapore region ( ap-southeast-1 ).
Infrastructure is composed of the below components in AWS Cloud
    - CDN: CloudFront
    - Layer 7 Protection against web attacks: AWS WAF
    - DDoS attack: AWS Shield
    - HTTPS Routing: AWS Application Load Balancer
    - Compute: AWS Elastic Kubernetes Services
    - Redis Datase: AWS MemoryDB
    - Application: Python
    - CI/CD: Gitlab Server, Gitlab Runner

![alt text](https://github.com/vidhush07/berkeley_project/blob/88b73870c2ec322c41170f6ebaba60c117577baa/docs/Images/low_level_architecture_diagram.drawio.png)

### Security:
    - Secrets Management: AWS Secret Manager used to store secrets.
    - AWS WAF to protect against Layer 7 Web attacks.
    - Separate Memory DB for Production and non-production.

### Network:
    - VPC Design: Separate VPCs for Ingress ALB, Production VPC, Non-production VPC and Jumphost VPC.
    - EC2 endpoint connect to access Jumphost vm using private ip address.
    - VPC endpoints to access resources such as S3, ECR, STS, Secrets manager, MemoryDB securely.

### CI/CD:
    - Gitlab Community Edition server is installed on Amazon Linux.
    - Gitlab Runner configured in the same server as of Gitlab server to deploy in Non-production and production cluster.
    - Pipeline Stages:
        1. Build Stage:
            - Build docker images.
            - Publish the docker images to ECR.
        2. Deploy Stages:
            - Kubernetes deployment.
            - Application pod validation step.

### Database:
    - Requirement is to use Redis Database and the AWS offerings are AWS ElastiCache and AWS memory DB.
    - AWS ElastiCache doesn't offer data persistence and advantageous for caching purposes. Elasticache is not built on redis.
    - AWS Memory DB offers data persistence with in-memory storage. Offers Redis OSS as the backend to the database. Hence AWS Memory DB is chosen for Application Data storage.

### Availability:
    - All the resources are built in all 3 availability zones ( "ap-southeast-1a","ap-southeast-1b","ap-southeast-1c" )

## Future Enhancements:

![alt text](https://github.com/vidhush07/berkeley_project/blob/main/docs/Images/future_enhance_Low_level_architecture_diagram.drawio.png)

### Security and Networking:
    - IAM: IAM roles with least privilege roles for resources to access.
    - Security groups to allow traffic only between required resources.
    - Kubernetes: EKS Pod Identity Agent for application pods to access the resources using IAM.
    - SonarQube to perform code quality checks and security vulnerability scanning.
    - AWS Shield to protect against DDoS attacks.


### CI/CD:
    - Gitlab Community Edition server to be configured in a separate EKS cluster in common VPC.
    - Gitlab Runner to be configured separately in Production EKS and Non-production EKS to access the cluster securely.
    - Flux Agent to be configured as GitOps solution to synchronize between repositiory and kubernetes deployment.

### Observability:
    - Prometheus to be configured to collect metrics data from application and infrastructure resources.
    - Thanos to be configured as sidecar containers with prometheus to perform long storage retention and also as a datasource for Grafana.
    - Grafana to be configured as central dashboard to collate all the monitoring data.
    - Opentelemetry instrumention to be setup with application code to send telemetry metrics. Opentelemetry collector will be configured as sidecar container to application pods for collecting and sending telemetry data to prometheus. 

## Issues Faced:
    - Traffic routing failure due to DNS resolution within VPC. Enabled DNS A record option to resolve the issue.
    - ECR public images were not accessible due to S3 gateway endpoint missing.
    - Traffic routing failure due to Security group missing ingress rules.
    - EKS route table not associated with S3 Gateway endpoint causing image pull error in EKS.
    - Gitlab runner registration failed due to not proper installation of TLS certificate in Gitlab server. Temporarily used AWS EC2 instance certificate and dns routing as a temporary workaround.
    - VPC Peering was not configured properly and routes were missing between VPC.
    - Application Pod issue due to AWS Memory DB authentication issue. IAM user got disabled. 

## Gitlab Documentation:
    - Refer the link to download the docx file. [click me to download](https://github.com/vidhush07/berkeley_project/blob/88b73870c2ec322c41170f6ebaba60c117577baa/docs/Images/gitlab.docx)
