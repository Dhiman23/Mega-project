
#this module is for security group
resource "aws_security_group" "ALL-server-sg" {
  name        = "web"
  description = "this is for the jenkins server"


  ingress {
    description = "port 8080 for jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port for ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port for sonarqube "
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port for mail notification"
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "port for virtual machine kubernetes cluster "
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port for kubernestes setup"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port for http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port for https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port for nexsus"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "web-sg"
  }



}



resource "aws_instance" "Master" {

  ami             = var.OS-east-1
  instance_type   = var.kube-server
  security_groups = [aws_security_group.ALL-server-sg.name]
  key_name        = "key-2024"
  user_data       = templatefile("./Kubeadm-master-Slave.sh", {})

  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  tags = {
    Name = "Master"
  }

  associate_public_ip_address = true

}


resource "aws_instance" "Slave1" {

  ami             = var.OS-east-1
  instance_type   = var.kube-server
  security_groups = [aws_security_group.ALL-server-sg.name]
  key_name        = "key-2024"
  user_data       = templatefile("./Kubeadm-master-Slave.sh", {})

  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  tags = {
    Name = "Slave"
  }

  associate_public_ip_address = true

}

resource "aws_instance" "Slave2" {

  ami             = var.OS-east-1
  instance_type   = var.kube-server
  security_groups = [aws_security_group.ALL-server-sg.name]
  key_name        = "key-2024"
  user_data       = templatefile("./Kubeadm-master-Slave.sh", {})

  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  tags = {
    Name = "Slave-2"
  }

  associate_public_ip_address = true

}


resource "aws_instance" "jenkins-server" {

  ami             = var.OS-east-1
  instance_type   = var.main-server
  security_groups = [aws_security_group.ALL-server-sg.name]
  key_name        = "key-2024"
  user_data       = templatefile("./jenkins.sh", {})
  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  tags = {
    Name = "main-server"
  }

  associate_public_ip_address = true

}

