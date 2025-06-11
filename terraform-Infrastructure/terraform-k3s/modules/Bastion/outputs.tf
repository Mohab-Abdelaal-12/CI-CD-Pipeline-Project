output "jenkins_url" {
  value = "http://${aws_instance.this.public_ip}:8080"
}

output "ssh" {
  value = "ssh -i your-key.pem ubuntu@${aws_instance.this.public_ip}"
}
