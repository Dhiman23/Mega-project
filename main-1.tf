
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


  #this is for elastic ip integration with the specific server/ec2

}
resource "aws_eip" "fork8s-server1" {
  instance = aws_instance.kubernests-M-1.id
}

# this is for creating the ec2 with all and packeges need to install
resource "aws_instance" "kubernests-M-1" {

  ami             = "ami-0b8b44ec9a8f90422"
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.ALL-server-sg.name]
  key_name        = "key"

  user_data = templatefile("./k8s-M.sh", {})
  root_block_device {
    volume_size = 25
    volume_type = "gp2"
  }

  tags = {
    Name = "Master1"
  }

  associate_public_ip_address = true

}


resource "aws_eip" "fork8s-server2" {
  instance = aws_instance.kubernests-S-1.id
}
resource "aws_instance" "kubernests-S-1" {

  ami             = "ami-0b8b44ec9a8f90422"
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.ALL-server-sg.name]
  key_name        = "key"
  user_data       = templatefile("./k8s-M-S.sh", {})
  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }


  tags = {
    Name = "Slave1"
  }

  associate_public_ip_address = true

}

resource "aws_eip" "fork8s-server3" {
  instance = aws_instance.kubernests-S-2.id
}
resource "aws_instance" "kubernests-S-2" {

  ami             = "ami-0b8b44ec9a8f90422"
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.ALL-server-sg.name]
  key_name        = "key"
  user_data       = templatefile("./k8s-M-S.sh", {})
  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  tags = {
    Name = "Slave2"
  }

  associate_public_ip_address = true

}

resource "aws_eip" "sonar-server" {
  instance = aws_instance.sonar-server.id
}
resource "aws_instance" "sonar-server" {

  ami             = "ami-0b8b44ec9a8f90422"
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.ALL-server-sg.name]
  key_name        = "key"
  user_data       = templatefile("./sonar.sh", {})
  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name = "Sonarqube"
  }

  associate_public_ip_address = true

}
resource "aws_eip" "nexsus-server" {
  instance = aws_instance.nexsus-server.id
}

resource "aws_instance" "nexsus-server" {

  ami             = "ami-0b8b44ec9a8f90422"
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.ALL-server-sg.name]
  key_name        = "key"
  user_data       = templatefile("./nexsus.sh", {})
  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name = "nexsus"
  }

  associate_public_ip_address = true

}

resource "aws_eip" "jenkins-server" {
  instance = aws_instance.jenkins-server.id
}

resource "aws_instance" "jenkins-server" {

  ami             = "ami-0b8b44ec9a8f90422"
  instance_type   = "t2.large"
  security_groups = [aws_security_group.ALL-server-sg.name]
  key_name        = "key"
  user_data       = templatefile("./jenkins.sh", {})
  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  tags = {
    Name = "Jenkins"
  }

  associate_public_ip_address = true

}


# output "aws_eip" {
#   value = [aws_instance.kubernests-M-1.public_ip,aws_instance.kubernestes-S-1.public_ip, aws_instance.kubernests-S-2.public_ip,aws_instance.sonar-server.public_ip,aws_instance.nexsus-server.public_ip,aws_instance.jenkins-server.public_ip]
# }