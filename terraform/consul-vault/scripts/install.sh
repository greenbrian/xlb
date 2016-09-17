#!/usr/bin/env bash
set -e

# Read from the file we created
SERVER_COUNT=$(cat /tmp/consul-server-count | tr -d '\n')
CONSUL_JOIN=$(cat /tmp/consul-server-addr | tr -d '\n')

# Write the flags to a temporary file
if [ "${CONSUL_JOIN}" == "$(hostname -f)" ]; then
cat >/tmp/consul_flags << EOF
CONSUL_FLAGS="-server -bootstrap-expect=${SERVER_COUNT} -join=${CONSUL_JOIN} -data-dir=/opt/consul/data -client 0.0.0.0 -ui -ui-dir=/opt/consul-ui"
EOF
else
cat >/tmp/consul_flags << EOF
CONSUL_FLAGS="-server -bootstrap-expect=${SERVER_COUNT} -join=${CONSUL_JOIN} -data-dir=/opt/consul/data"
EOF
fi



if [ -f /tmp/upstart.conf ];
then
  echo "Installing Upstart service..."
  sudo mkdir -p /etc/consul.d
  sudo mkdir -p /etc/service
  sudo chown root:root /tmp/upstart.conf
  sudo mv /tmp/upstart.conf /etc/init/consul.conf
  sudo chmod 0644 /etc/init/consul.conf
  sudo mv /tmp/consul_flags /etc/service/consul
  sudo chmod 0644 /etc/service/consul
else
  echo "Installing Systemd service..."
  sudo mkdir -p /etc/systemd/system/consul.d
  sudo chown root:root /tmp/consul.service
  sudo mv /tmp/consul.service /etc/systemd/system/consul.service
  sudo chmod 0644 /etc/systemd/system/consul.service
  sudo mv /tmp/consul_flags /etc/default/consul
  sudo chown root:root /etc/default/consul
  sudo chmod 0644 /etc/default/consul
fi
