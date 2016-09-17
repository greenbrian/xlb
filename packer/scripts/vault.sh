#!/usr/bin/env bash

set -e

echo "Fetching Vault..."
VAULT=0.6.1
cd /tmp
wget https://releases.hashicorp.com/vault/${VAULT}/vault_${VAULT}_linux_amd64.zip \
    --quiet \
    -O vault.zip

echo "Installing Vault..."
unzip -q vault.zip >/dev/null
chmod +x vault
sudo mv vault /usr/local/bin/vault
