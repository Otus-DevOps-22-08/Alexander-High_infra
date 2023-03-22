#!/bin/bash
apt install git -y
sleep 30
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
ps aux | grep puma
