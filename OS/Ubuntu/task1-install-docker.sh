#!/bin/bash
source ./environment.sh
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo apt-get update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo apt-get install -y docker-ce=$DOCKER_VERSION_STRING docker-ce-cli=$DOCKER_VERSION_STRING containerd.io
sudo groupadd docker
sudo usermod -aG docker ${USER}
su -s ${USER}
docker login 
sudo docker run hello-world
