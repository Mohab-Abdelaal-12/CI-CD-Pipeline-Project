variable "name" {
  description = "Name prefix for the ALB and resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "node_ip" {
  type = string
}


variable "node_port" {
  description = "NodePort exposed by the Traefik service"
  type        = number
}
