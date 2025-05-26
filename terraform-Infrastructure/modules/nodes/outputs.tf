output "master_id" {
  value = aws_instance.master.id
}

output "master_ip" {
  value = aws_instance.master.private_ip
}

output "worker_ips" {
  value = [for instance in aws_instance.worker : instance.private_ip]
}
