#!/bin/bash

dnf install -y docker

systemctl enable docker

systemctl start docker

usermod -aG docker opc

mkdir -p /opt/wordpress