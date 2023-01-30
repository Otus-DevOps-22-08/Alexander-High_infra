#!/bin/bash
apt install mc vim git apt-transport-https ca-certificates -y
apt install gnupg -y
apt update -y
apt upgrade -y
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt update -y
apt install -y mongodb-org
systemctl daemon-reload
systemctl enable mongod
systemctl start mongod
systemctl status mongod
