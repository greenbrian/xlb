variable "user" {}
variable "key_path" {}
variable "consul_server_count" {}
variable "subnet_id" {}
variable "xlb_sg_id" {}

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
    instance_type = "t2.micro"
    count = "${var.consul_server_count}"
    subnet_id = "${var.subnet_id}"
    vpc_security_group_ids = ["${var.xlb_sg_id}"]
    tags = {
      env = "xlb-demo"
    }
    connection {
        user = "${var.user}"
        key_file = "${var.key_path}"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${var.consul_server_count} > /tmp/consul-server-count",
            "echo ${aws_instance.consul-vault.0.private_dns} > /tmp/consul-server-addr",
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

    provisioner "remote-exec" {
        inline = [
            "sudo systemctl enable vault.service",
            "sudo systemctl start vault"
        ]
    }

/*  ###################   WARNING    #########################  */
/* The following steps are not recommended for production usage */
/* The script will initialize your vault and store the secret   */
/* keys insecurely and is only used for demonstration purposes  */

    provisioner "file" {
        source = "${path.module}/scripts/setup_vault.sh",
        destination = "/tmp/setup_vault.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x /tmp/setup_vault.sh",
            "nohup /tmp/setup_vault.sh &",
            "sleep 1"
        ]
    }
}
