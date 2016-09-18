output "haproxy_address" {
  value = "ssh://${aws_instance.haproxy.0.public_dns}"
}
