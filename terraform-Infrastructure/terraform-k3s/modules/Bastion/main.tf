resource "aws_instance" "this" {
  ami                         = "ami-084568db4383264d4"
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              set -e
              # تحديث النظام
              sudo apt-get update -y
              sudo apt-get upgrade -y
              # تثبيت المتطلبات الأساسية
              sudo apt-get install -y software-properties-common gnupg curl ca-certificates apt-transport-https lsb-release
              # -----------------------------
              # تثبيت Java 17
              # -----------------------------
              sudo add-apt-repository ppa:openjdk-r/ppa -y
              sudo apt-get update -y
              sudo apt-get install -y openjdk-17-jdk

              # -----------------------------
              # تثبيت Jenkins (بدون GPG check)
              # -----------------------------
              echo "deb [trusted=yes] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
              sudo apt-get update -y
              sudo apt-get install -y jenkins
              sudo systemctl enable jenkins
              sudo systemctl start jenkins

              # -----------------------------
              # تثبيت Ansible (بدون GPG check)
              # -----------------------------
              sudo add-apt-repository --yes --no-update ppa:ansible/ansible
              sudo sed -i 's/^deb /deb [trusted=yes] /' /etc/apt/sources.list.d/ansible-ubuntu-ansible-*.list
              sudo apt-get update -y
              sudo apt-get install -y ansible

              # -----------------------------
              # تثبيت Docker (بدون GPG check)
              # -----------------------------
              sudo mkdir -p /etc/apt/keyrings
              echo "deb [arch=$(dpkg --print-architecture) trusted=yes] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
              sudo apt-get update -y
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io

              # تشغيل Docker تلقائياً
              sudo systemctl enable docker
              sudo systemctl start docker

              # إضافة المستخدم الافتراضي إلى مجموعة docker
              sudo usermod -aG docker ubuntu || true

              # -----------------------------
              # فتح منفذ Jenkins (اختياري)
              # -----------------------------
              sudo ufw allow 8080 || true
              EOF

  tags = {
    Name = "jenkins-bastion"
  }
}
