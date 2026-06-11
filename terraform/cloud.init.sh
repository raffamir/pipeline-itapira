#!/bin/bash

# Cria swap de 2GB
fallocate -l 2G /swapfile

chmod 600 /swapfile

mkswap /swapfile

swapon /swapfile

echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

# Aguarda estabilizar
sleep 30

# Instala Docker
dnf install -y docker

# Habilita Docker
systemctl enable docker

systemctl start docker

# Permissões
usermod -aG docker opc

# Evidência
docker --version > /tmp/docker-version.txt

echo "Provisionamento concluído" > /tmp/provisioning-ok.txt