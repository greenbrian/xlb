variable "user" {}
variable "key_path" {}
variable "private_key" {}
variable "consul_server_count" {
  description = "Number of Consul servers to launch"
  default = "3"
}
variable "nomad_server_nodes" {
  description = "Number of Nomad servers to launch"
  default = "3"
}
variable "nomad_client_nodes" {
  description = "Number of Nomad clients to launch"
  default = "3"
}
