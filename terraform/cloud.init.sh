user_data = base64encode(<<-EOF
#!/bin/bash

fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

apt update

apt install -y docker.io

systemctl enable docker

systemctl start docker

usermod -aG docker ubuntu

echo "Docker OK" > /tmp/docker-ok.txt

EOF
)