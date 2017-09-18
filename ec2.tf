// Amazon Linux
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2017.03.1.${var.amazon_linux_release}-x86_64-gp2"]
  }
}

// --- Security Groups ---
// Allows SSH
resource "aws_security_group" "ssh_access" {
  name        = "ssh-sg-${var.region}"
  description = "opens correct ports for ssh to ${var.region} instances"
  vpc_id      = "${aws_vpc.cc2017_vpc.id}"

  // Assumes default ports
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Per docs, this means allow all leaving.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Allows 3000
resource "aws_security_group" "node_access" {
  name        = "node-sg-${var.region}"
  description = "opens correct ports for node"
  vpc_id      = "${aws_vpc.cc2017_vpc.id}"

  // Assumes default ports
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Per docs, this means allow all leaving.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "node_instance" {
  instance_type          = "${var.instance_type}"
  ami                    = "${data.aws_ami.amazon_linux.id}"
  vpc_security_group_ids = ["${aws_security_group.ssh_access.id}", "${aws_security_group.node_access.id}"]
  key_name               = "${var.ssh_key}"
  subnet_id              = "${aws_subnet.cc2017_subnet.id}"

  tags {
    Name        = "CodeCamp2017"
    BuiltBy     = "Terraform"
  }

  provisioner "file" {
    source      = "app"
    destination = "/tmp"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("keys/${var.ssh_key}.pem")}"
    }
  }

  // Added sleeps to ensure EMR is created for Presto health checks
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum install -y nodejs npm --enablerepo=epel",
      "sudo npm install -g express",
      "chmod 755 /tmp/app/start.sh",
      "/tmp/app/start.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("keys/${var.ssh_key}.pem")}"
    }
  }
}
