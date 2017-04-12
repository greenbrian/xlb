#!/usr/bin/env bash
set -e

# Read from the file we created
SERVER_COUNT=$(cat /tmp/consul-server-count | tr -d '\n')
CONSUL_JOIN=$(cat /tmp/consul-server-addr | tr -d '\n')
INSTANCE_PRIVATE_IP=$(ifconfig eth0 | grep "inet addr" | awk '{ print substr($2,6) }')


# Write the flags to a temporary file
# enable UI for first node in cluster
if [ "${CONSUL_JOIN}" == "$(hostname -f)" ]; then

# Setup Consul UI on primary Consul server
sudo bash -c "cat >/etc/default/consul" << EOF
CONSUL_FLAGS="\
-join=${CONSUL_JOIN} \
-client 0.0.0.0 -ui \
-advertise=${INSTANCE_PRIVATE_IP} \
-ui-dir=/opt/consul-ui"
EOF

# setup consul UI specific iptables rules
sudo iptables -I INPUT -s 0/0 -p tcp --dport 8500 -j ACCEPT
sudo iptables-save | sudo tee /etc/iptables.rules

else

sudo bash -c "cat >/etc/default/consul" << EOF
CONSUL_FLAGS="\
-join=${CONSUL_JOIN} \
-advertise=${INSTANCE_PRIVATE_IP} \
-data-dir=/opt/consul/data"
EOF
fi

sudo chown root:root /etc/default/consul
sudo chmod 0644 /etc/default/consul
