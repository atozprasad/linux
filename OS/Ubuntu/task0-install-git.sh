#!/bin/bash
figlet "Setup- kind"
#Download bits
echo -e "\n Downloading bits from internet"
sudo apt-get update 
sudo apt-get install git
#change file permissions 
#Move the binary in to your PATH.
#Test to ensure the version you installed is up-to-date:

git --version git version 2.9.2
git config --global credential.helper store
figlet "Done with this step"
echo -e "\n NextStep...";read;clear

