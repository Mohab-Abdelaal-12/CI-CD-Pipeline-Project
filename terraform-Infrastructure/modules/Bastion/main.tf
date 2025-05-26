resource "aws_instance" "this" {
  ami                         = "ami-084568db4383264d4"
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io openjdk-17-jdk
              systemctl enable docker

              echo "deb https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee \
                  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
              apt-get update -y
              apt-get install -y jenkins 
              usermod -aG docker jenkins
              EOF

  tags = {
    Name = "jenkins-bastion"
  }
}
