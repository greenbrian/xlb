output "consul_addresses" {
  value = ["${module.consul-vault.consul_addresses}"]
}

output "consul_ui" {
    value = "${module.consul-vault.consul_ui}"
}

output "haproxy_address" {
    value = "${module.haproxy.haproxy_address}"
}

output "nginx_addresses" {
    value = "${module.nginx.nginx_addresses}"
}
