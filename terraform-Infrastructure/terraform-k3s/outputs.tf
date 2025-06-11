output "jenkins_url" {
  value = module.bastion.jenkins_url
}

output "bastion_ssh" {
  value = module.bastion.ssh
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "master_ip" {
  value = module.nodes.master_ip
}

output "worker_private_ips" {
  value = module.nodes.worker_private_ips
}
