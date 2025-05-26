resource "aws_instance" "master" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              EOF

  tags = {
    Name = "k3s-master"
  }
}

resource "aws_instance" "worker" {
  count         = 2
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              EOF

  tags = {
    Name = "k3s-worker-${count.index + 1}"
  }
}
