#!/usr/bin/env bash

sudo mkdir -p /var/log/nginx
#sudo chown  /var/log/nginx
sudo chmod -R 755 /var/log/nginx
sudo apt-get install -y -q nginx

# setup nginx iptables rules
sudo iptables -I INPUT -s 0/0 -p tcp --dport 80 -j ACCEPT

sudo netfilter-persistent save
sudo netfilter-persistent reload
