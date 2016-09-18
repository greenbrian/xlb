#!/usr/bin/env bash

# install haproxy
sudo apt-get install -y -q haproxy

# setup haproxy iptables rules
sudo iptables -I INPUT -s 0/0 -p tcp --dport 80 -j ACCEPT

sudo netfilter-persistent save
sudo netfilter-persistent reload
