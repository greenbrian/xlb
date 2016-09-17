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

/*  commenting these out for now
#########

module "haproxy" {
  source = "./haproxy"
  user = "${var.user}"
  key_path = "${var.key_path}"
}

module "nginx" {
  source = "./nginx"
  user = "${var.user}"
  key_path = "${var.key_path}"
  nginx_server_count = 2
}

#########
*/

output "consul_addresses" {
  value = ["${module.consul-vault.consul_addresses}"]
}

output "consul_ui" {
    value = "${module.consul-vault.consul_ui}"
}
