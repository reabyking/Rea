# REA Group simple-sinatra-app Solution

Please see the below solution to the REA Group Systems Engineer Test.
This solution has been tested and run from an Ubuntu Lastet Image 18.04 Docker image with the below requirements installed. My docker repository name is set as reabyorg/rea. 


## Table of Contents
  * [Manual build your Docker image](#build)
    - [Requirements to Run](#req-run)
    - [Build your own image process](#mbuild)
  * [Automatic build your Docker image](#auto-build)
  * [Deploy your Docker image](#deploy)
  * [Security Enhancement](#security)
    - [Docker](#sec-Docker)
    - [Server (Ubuntu)](#sec-server)
    - [Extra considerations](#sec-consider)
  * [Why Docker](#reason)

## Manual build your Docker imag<a id="build"></a>

### Requirements to Run for manual build image <a id="req-run"></a>
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


## Build your own image process <a id="mbuild"></a>


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
docker commit <your local Docker container ID> reabyorg/rea:latest

# Docker Run your image in new container
docker run -it -p 80:80 -w /rea reabyorg/rea:latest bash

# Start simple-sinatra-app 
ruby helloworld.rb -o 0.0.0.0
## OR Start APP with "bundle exec rackup -p 80 --host 0.0.0.0"

# Upload your own Docker image to Docker Hub (optional)
docker push reabyorg/rea:latest


# Note: 
# All codes above are for manual build Docker images.
```


## Automatic build your Docker image<a id="auto-build"></a>
For the below points, Docker image is built automatically with Dockerfile. Basically, the Dockerfile is replacing all manual image build process. 

 ```bash
# Get your Dockerfile ready 
FROM ubuntu:latest
MAINTAINER Nathan <r@reaby.org>

RUN apt-get update &&  apt-get install -y git && apt-get install -y ruby && gem install bundler

ENV APP_HOME /rea
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
RUN git init && git pull https://github.com/rea-cruitment/simple-sinatra-app.git
RUN bundle install

ENV PORT 80
EXPOSE 80
CMD ["ruby","helloworld.rb","-o","0.0.0.0"]

# Build your docker image with Dockerfile
docker build -t reabyorg/rea:latest .

# Docker Run your image in new container
docker run -p 80:80 reabyorg/rea:latest

# Upload your own Docker image to Docker Hub (optional)
docker push reabyorg/rea:latest

```

## Deploy your Docker image <a id="deploy"></a>

```bash
# Deploy your own image 
docker pull reabyorg/rea:latest

# Docker Run your image in new container
docker run -p 80:80 reabyorg/rea:latest
```

## Security Enhancement <a id="security"></a>
#### Docker  <a id="sec-Docker"></a>

- Docker only allow port 80 incoming tracffic to Ubuntu system. 
- Enhanced network security by design, only desinated port expose to external.

#### Server (Ubuntu)  <a id="sec-server"></a>
- Unhackable system level. Root account password is NOT enabled. Console Root access via Docker enviroment.
- Unhackable network level. Only Http port 80 is enabled. SSH Server is NOT enabled. 
- UFW is NOT enabled. Not need maintain UFW firewall. 
- Operating System patches up to date including Kernel Versions.

## Extra considerations for production  <a id="sec-consider"></a>
- Use Nginx or Apache for web service. 
- HA with load balancer.
- Enable Root password for system level protection.
- Batch deployment with Automation tools, Kubernetes or Ansible. 
- Deploy WAF to protect app level security.
- Review SSL protocal and certificate and enforce SSL for all traffic. 
- Use private Docker repository to protect your own Image instead of Docker Hub.

## Why Docker <a id="reason"></a>
My reasoning behind using the mix of Docker and Ubuntu is listed below:
- Docker fits for any Infrastructure: Public clouds (AWS, Azure, Google Cloud, etc.) or On-premises
- Docker fits for any Operating System: CentOS, Oracle Linux, RHEL, SUSE, Ubuntu,
Windows Server 2016, Windows 10. For example, this solution is built on Special Linux, tested on Windows and Ubuntu. 
- Docker has Unified and Automated Operations. With a pre-built image, a new Global scale service  could be deployed in a few seconds. 
- Fast deployment. Get App running in a few seconds, except downloading Docker and image. 
- Continuous integration (CI) for automated build and testing as well as continuous delivery (CD) for deploying versions to the different environments.


