#!/usr/bin/env bash

sudo mkdir -p /var/log/nginx
#sudo chown  /var/log/nginx
sudo chmod -R 755 /var/log/nginx
sudo apt-get install -y -q nginx
