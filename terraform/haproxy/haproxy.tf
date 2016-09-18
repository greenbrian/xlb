variable "user" {}
variable "key_path" {}
variable "primary_consul" {}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "name"
    values = ["ubuntu-16-haproxy*"]
  }
}


resource "aws_instance" "haproxy" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t1.micro"
    count = "1"
    security_groups = ["${aws_security_group.haproxy.name}"]
    tags = {
      env = "xlb-demo"
    }
    connection {
        user = "${var.user}"
        key_file = "${var.key_path}"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${var.primary_consul} > /tmp/consul-server-addr",
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/install.sh"
        ]
    }

    provisioner "remote-exec" {
        inline = [
            "sudo systemctl enable consul.service",
            "sudo systemctl start consul"
        ]
    }
}

resource "aws_security_group" "haproxy" {
    name = "haproxy"
    description = "HAProxy internal traffic + maintenance."

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

    // This is for HAProxy inbound
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

}
