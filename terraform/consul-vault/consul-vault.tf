variable "user" {}
variable "key_path" {}
variable "consul_server_count" {}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "name"
    values = ["ubuntu-16-consul-vault*"]
  }
}

resource "aws_instance" "consul-vault" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t1.micro"
    count = "${var.consul_server_count}"
    security_groups = ["${aws_security_group.consul.name}"]
    tags = {
      env = "xlb-demo"
    }
    connection {
        user = "${var.user}"
        key_file = "${var.key_path}"
    }

    provisioner "file" {
        source = "${path.module}/scripts/consul.service"
        destination = "/tmp/consul.service"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${var.consul_server_count} > /tmp/consul-server-count",
            "echo ${aws_instance.consul-vault.0.private_dns} > /tmp/consul-server-addr",
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/install.sh",
            "${path.module}/scripts/service.sh",
            "${path.module}/scripts/iptables.sh"
        ]
    }
}

resource "aws_security_group" "consul" {
    name = "consul"
    description = "Consul internal traffic + maintenance."

    // These are for internal traffic
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
    }

    // These are for maintenance
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // This is for Consul UI
    ingress {
        from_port = 8500
        to_port = 8500
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

output "consul_addresses" {
  value = "${formatlist("ssh://%s", aws_instance.consul-vault.*.public_dns)}"
}

output "consul_ui" {
  value = "http://${aws_instance.consul-vault.0.public_dns}:8500/ui/"
}
