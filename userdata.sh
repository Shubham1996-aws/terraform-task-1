#!/bin/bash

sudo yum update -y       
sudo yum install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user

docker version
if [ $? = 0 ]
then
echo "docker installed"
else
echo "docker not installed"
fi
