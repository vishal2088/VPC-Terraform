// The main file to deploy our webserver

// security group
resource "aws_security_group" "web" {
  name                        = "vpc_web"
  description                 = "Allow incoming HTTP connections."
  vpc_id                      = "${var.vpc_id}"

  ingress {
    from_port                 = 22
    to_port                   = 22
    protocol                  = "tcp"
    cidr_blocks               = ["0.0.0.0/0"]
  }

  ingress {
    from_port                 = 80
    to_port                   = 80
    protocol                  = "tcp"
    cidr_blocks               = ["0.0.0.0/0"]
  }

  ingress {
    from_port                 = -1
    to_port                   = -1
    protocol                  = "icmp"
    cidr_blocks               = ["0.0.0.0/0"]
  }

  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["0.0.0.0/0"]
  }

  tags {
    Name                      = "WebServerSG"
  }
}

// Our instance
resource "aws_instance" "web-1" {
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.web.id}"]
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = "${file("${path.module}/update.sh")}"

  tags {
    Name                      = "Web Server 1"
    }
  
provisioner "local-exec" {
    command = "sleep 180; cd webserver; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ./codedeploy.pem ./site.yml"
}
}
