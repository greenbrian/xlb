#!/usr/bin/env bash
#######################################
# NOMAD CONFIGURATION
#######################################

INSTANCE_PRIVATE_IP=$(ifconfig eth0 | grep "inet addr" | awk '{ print substr($2,6) }')
INSTANCE_HOST_NAME=$(hostname)
nomad_server_nodes=3

sudo mkdir -p /etc/systemd/system/nomad.d/
sudo tee /etc/systemd/system/nomad.d/nomad.hcl > /dev/null <<EOF
name       = "${INSTANCE_HOST_NAME}"
data_dir   = "/opt/nomad/data"
log_level  = "DEBUG"
datacenter = "dc1"
bind_addr = "0.0.0.0"
server {
  enabled          = true
  bootstrap_expect = ${nomad_server_nodes}
}
addresses {
  rpc  = "${INSTANCE_PRIVATE_IP}"
  serf = "${INSTANCE_PRIVATE_IP}"
}
advertise {
  http = "${INSTANCE_PRIVATE_IP}:4646"
}
consul {
}
EOF

#######################################
# START SERVICES
#######################################

sudo systemctl enable nomad.service
#sudo systemctl start nomad
