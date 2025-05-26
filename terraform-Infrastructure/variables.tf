variable "region" {
  default = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "public_azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "private_azs" {
  type    = list(string)
  default = ["us-east-1a"]
}
