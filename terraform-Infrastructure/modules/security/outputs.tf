output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}

output "nodes_sg_id" {
  value = aws_security_group.nodes.id
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}
