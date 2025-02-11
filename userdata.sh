#!/bin/bash
yum update -y
amazon-linux-extras enable docker
yum install -y docker
systemctl enable --now docker
usermod -aG docker ec2-user
echo "Docker installed!" > /home/ec2-user/docker.txt
