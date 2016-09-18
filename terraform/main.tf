provider "aws" {
    access_key = ""
    secret_key = ""
    region = "us-west-1"
}

module "consul-vault" {
  source = "./consul-vault"
  user = "${var.user}"
  key_path = "${var.key_path}"
  consul_server_count = 3
}


module "haproxy" {
  source = "./haproxy"
  user = "${var.user}"
  key_path = "${var.key_path}"
  primary_consul = "${module.consul-vault.primary_consul}"
}


module "nginx" {
  source = "./nginx"
  user = "${var.user}"
  key_path = "${var.key_path}"
  nginx_server_count = 2
  primary_consul = "${module.consul-vault.primary_consul}"
}
