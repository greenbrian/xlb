variable "user" {}
variable "key_path" {}

variable "consul_server_count" {
  description = "Number of Consul servers to launch"
  default = "3"
}
