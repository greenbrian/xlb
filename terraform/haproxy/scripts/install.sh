#!/usr/bin/env bash
set -e

# Read from the file we created
CONSUL_JOIN=$(cat /tmp/consul-server-addr | tr -d '\n')

sudo bash -c "cat >/etc/default/consul" << EOF
CONSUL_FLAGS="\
-join=${CONSUL_JOIN} \
-data-dir=/opt/consul/data"
EOF

sudo chown root:root /etc/default/consul
sudo chmod 0644 /etc/default/consul
