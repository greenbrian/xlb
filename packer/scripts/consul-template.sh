#!/usr/bin/env bash

set -e

echo "Fetching Consul Template..."
VERSION=0.15.0
cd /tmp
wget https://releases.hashicorp.com/consul-template/${VERSION}/consul-template_${VERSION}_linux_amd64.zip \
    --quiet \
    -O consul_template.zip

echo "Installing Consul Template..."
unzip -q consul_template.zip >/dev/null
chmod +x consul-template
sudo mv consul-template /usr/local/bin/consul-template
