#!/usr/bin/env bash

set -e

echo "Fetching Consul..."
CONSUL=0.6.4
cd /tmp
wget https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_amd64.zip \
    --quiet \
    -O consul.zip

echo "Installing Consul..."
unzip -q consul.zip >/dev/null
chmod +x consul
sudo mv consul /usr/local/bin/consul
sudo mkdir -p /opt/consul/data
