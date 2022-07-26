// The main file to deploy our database

// security group
resource "aws_security_group" "db" {
  name                    = "vpc_db"
  description             = "Allow incoming database connections."
  vpc_id                  = "${var.vpc_id}"

  ingress {
    from_port             = 3306
    to_port               = 3306
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  ingress {
    from_port             = 22
    to_port               = 22
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  ingress {
    from_port             = -1
    to_port               = -1
    protocol              = "icmp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  egress {
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  tags {
    Name                  = "DBServerSG"
  }
}

resource "aws_instance" "db-1" {
  ami                     = "${var.ami}"
  instance_type           = "${var.instance_type}"
  key_name                = "${var.aws_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.db.id}"]
  subnet_id               = "${var.subnet_id}"
  user_data               = "${file("${path.module}/db.sh")}"
  source_dest_check       = false
  //depends_on              = ["aws_nat_gateway.gw"]
  
  tags {
    Name                  = "DB Server 1"
  }
}