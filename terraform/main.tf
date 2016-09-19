provider "aws" {
    access_key = ""
    secret_key = ""
    region = "us-west-1"
}

module "network" {
  source = "./network"
}

module "consul-vault" {
  source = "./consul-vault"
  user = "${var.user}"
  key_path = "${var.key_path}"
  consul_server_count = 3
  subnet_id = "${module.network.subnet_id}"
  xlb_sg_id ="${module.network.xlb_sg_id}"
}

module "haproxy" {
  source = "./haproxy"
  user = "${var.user}"
  key_path = "${var.key_path}"
  primary_consul = "${module.consul-vault.primary_consul}"
  subnet_id = "${module.network.subnet_id}"
  xlb_sg_id ="${module.network.xlb_sg_id}"
}

module "nginx" {
  source = "./nginx"
  user = "${var.user}"
  key_path = "${var.key_path}"
  nginx_server_count = 2
  primary_consul = "${module.consul-vault.primary_consul}"
  subnet_id = "${module.network.subnet_id}"
  xlb_sg_id ="${module.network.xlb_sg_id}"
}
