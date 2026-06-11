#!/bin/bash

apt-get update

apt-get install -y docker.io

apt-get install -y docker-compose-v2

systemctl enable docker

systemctl start docker

usermod -aG docker ubuntu