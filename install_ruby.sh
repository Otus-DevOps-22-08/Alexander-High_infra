#!/bin/bash
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential --allow-unauthenticated
ruby -v
bundler -v
