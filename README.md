# REA Group simple-sinatra-app Solution

Please see the below solution to the REA Group Systems Engineer Test.
This solution has been tested and run from an Ubuntu Lastet Image 18.04 Docker image with the below requirements installed.


## Table of Contents
  * [Requirements to Run ](#req-run)
  * [How to Build your own image](#build)
  * [Deploy your image with Docker to any cloud or system](#deploy)
  * [Security Enhancement](#security)
    - [Docker](#sec-Docker)
    - [NGINX](#sec-nginx)
    - [Server (Ubuntu)](#sec-server)
    - [Extra considerations for prod](#sec-consider)
  * [Reasoning for choices](#reason)


## Requirements to Run  <a id="req-run"></a>
For the below points that require installation i have place some breif instructions for how to install them on an Ubuntu System.
Also the Links will take you to some useful pages for how to install or get access to each requirement.
  - [Run Docker](https://docs.docker.com/machine/get-started/)

 ```bash
     # Docker can be ran any OS. This solution is built on Synology NAS Special Linux version 3.10.105  (gcc version 4.9.3 20150311) and tested on Windows and Linux system. 
     
 ```   
  - [Ubuntu on Docker](https://hub.docker.com/_/ubuntu)

 ```bash
     # Pull latest ubuntu image for Docker Hub
     docker pull ubuntu
     docker run --name rea -it ubuntu:latest bash
 ```   

  - [Git](https://help.ubuntu.com/lts/serverguide/git.html.en)
 ```bash
     # Ubuntu on Docker bash running with Root account, sudo is not required below.  
     apt-get update
     apt install --assume-yes git
 ```

  - [Ruby and Bundler](https://www.ruby-lang.org/en/documentation/installation/#apt)
 ```bash
     apt install --assume-yes ruby  
     gem install bundler
 ```


## How to Build your own image <a id="build"></a>


 ```bash
# Create App dictionary  
Mkdir rea
cd rea

# Git pull REA Group simple-sinatra-app
git init
git pull https://github.com/rea-cruitment/simple-sinatra-app.git

# Bundle install REA Group simple-sinatra-app
Bundle install 

# Quit Ubuntu Container and build your image
Exit

# List local Docker containers 
docker ps -a 
# Build your image with Docker
docker commit <your local Docker container ID> <your docker repository name>/rea:latest
# Upload your own Docker image to Docker Hub
docker push <your docker repository name>/rea:latest

```

## Deploy your image with Docker to any cloud or system <a id="deploy"></a>

 ```bash
# Docker download your own image 
docker pull reabyorg/rea:latest

# Docker Run your image in new container
docker run -it -p 80:80 -w /rea reabyorg/rea:latest bash

# Start simple-sinatra-app 
bundle exec rackup -p 80 --host 0.0.0.0

# Note: 
# Deploy and Run new service in a few seconds except downloading image. 
```



## Security Enhancement <a id="security"></a>


#### Docker  <a id="sec-Docker"></a>
- Unified and Automated Operations.
- Fit for any Infrastructure: Public clouds (AWS, Azure, Google Cloud, etc.) or On-premises
- Fit for any Operating System: CentOS, Oracle Linux, RHEL, SUSE Enterprise Linux, Ubuntu,
Windows Server 2016, Windows 10
- Enhanced network security by design, only desinated port expose to external.
- Docker only allow port 80 incoming tracffic to Ubuntu system. 



#### Server (Ubuntu)  <a id="sec-server"></a>
- Unhackable system level. Root account password is NOT enabled. Console Root access via Docker enviroment.
- Unhackable network level. Only Http port 80 is enabled. SSH Server is NOT enabled. 
- UFW is NOT enabled. Not need maintain UFW firewall. 
- Operating System patches up to date including Kernel Versions.




#### Extra considerations for production  <a id="sec-consider"></a>
- HA with load balancer.
- Enable Root password for system level protection.
- Batch deployment with Automation tools, Ansible 
- User Docker Enterprise to protect your own Image instead of Docker Hub.
- Deploy WAF to protect app level security.
- Review SSL protocal and certificate and enforce SSL for all traffic. 

```
- Geo IP based DNS using AWS Route 53
- HTTPS only with http to https redirect
- Weak SSL ciphers disabled and SSLv2 + SSLv3 and TLS1.0 Disabled
- Use a fully PCI Hardened Server not for PCI requirements but for best practice of securing systems or use a CIS (center for internet Security) AMI
- Regular security & Vulnerability scanning
- Monitoring of Server and Application
- Along with the above in a production environment you would also want to ensure that the application is version controlled and thoroughly tested.
- The last consideration would be to use a local repo for the gems and packages as so to keep the versions in line with the application and freeze versions when required to save errors due to version incompatibilities
```


## Reasoning for choices  <a id="reason"></a>
My reasoning behind using the mix of Docker is listed below:
- Fit for any Infrastructure: Public clouds (AWS, Azure, Google Cloud, etc.) or On-premises
- Fit for any Operating System: CentOS, Oracle Linux, RHEL, SUSE, Ubuntu,
Windows Server 2016, Windows 10. This solution is built on Special Linux, tested on Windows and Ubuntu. 
- Docker has Unified and Automated Operations. With a pre-built image, a new Global scale service  could be deployed in a few seconds. 
- Fast deployment. Get App running in a few seconds, except downloading Docker and image. 

```
- Simple & easily readable configuration as code ( Ansible Playbook )
- Amazing integration of Ansible to deploy into an AWS environment
- AWS is a reliable Cloud based provider with great features for security e.g. (Security Groups, built in WAF, ELB)
- Attempted use of Vagrant to many moving parts and easy to break (Reason for not using the Vagrant solution)
- Ansibles ability to ensure same results on every run.
- Faster deployment using AWS AMI's over downloading Vagrant images (Reason for not using the Vagrant solution)
``` 



```

The Anibsle playbook provided will do the below:
- Create an AWS security group only allow ports 80/http and 22/ssh to this server from all IP's
- Create an AWS Key pair called ( sinarta-aws-key ) and store it in the dir called *aws-keys* as a .pem file
- Launch an EC2 Instance from an AWS provided Ubuntu AMI (ami-1e01147d) in the region of (ap-southeast-2) with a label of (rea-sinatra-app)
-  Wait for SSH to become available
-  Save the IP to the hosts file located with the Ansible Playbook
-  The playbook will automatically connect to the EC2 instance and begin configuration of the required packages for the Sinatra app ( Nginx, Passenger, Ruby, e.t.c)


#### AWS  <a id="sec-aws"></a>
- Security Group only allowing ports 80/http and 22/ssh to the server
- New Key Pair for the environment as so not have a single master Key

#### Nginx (Web server)  <a id="sec-nginx"></a>
- Disabled Server token (  sever_tokens: off; )
- No Sniff Header along with the Content-Type header to disable content type sniffing ( add-header X-Content-Type-Options nosniff; )
- XSS Protection ( add-header X-XSS-Protection "1; mode=block"; )
- GZip Compression Enabled


#### Server (Ubuntu)  <a id="sec-server"></a>
- Root account password is NOT enabled. Not hackable. Console Root access via Docker enviroment.
- Only Http port 80 is enabled. SSH Server is NOT enabled. 
- UFW is NOT enabled. Not need maintain UFW firewall. 
- Operating System patches up to date including Kernel Versions.


- Ufw enabled with all incoming ports block other than 80/http and 22/ssh
- Ufw configured to deny SSH connections if an IPaddress has attempted to initiate 6 or more connections in the last 30 seconds
- Application Code stored in /app
- Application given dedicated user account (app_sinatra)
- Disabled ROOT SSH access
- Disabled Password SSH access key based authentication only
- Set local account password complexity requirements



``` 
