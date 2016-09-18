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

echo "Installing Systemd service..."
sudo mkdir -p /etc/systemd/system/consul.d

# setup consul iptables rules
sudo iptables -I INPUT -s 0/0 -p tcp --dport 8300 -j ACCEPT
sudo iptables -I INPUT -s 0/0 -p tcp --dport 8301 -j ACCEPT
sudo iptables -I INPUT -s 0/0 -p tcp --dport 8302 -j ACCEPT
sudo iptables -I INPUT -s 0/0 -p tcp --dport 8400 -j ACCEPT
sudo netfilter-persistent save
sudo netfilter-persistent reload


sudo bash -c "cat >/etc/systemd/system/consul.service" << 'EOF'
[Unit]
Description=consul agent
Requires=network-online.target
After=network-online.target

[Service]
EnvironmentFile=-/etc/default/consul
Restart=on-failure
ExecStart=/usr/local/bin/consul agent $CONSUL_FLAGS -config-dir=/etc/systemd/system/consul.d
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 0644 /etc/systemd/system/consul.service
