variable "vpc_id" {
  type = string
}

variable "public_azs" {
  type = list(string)
}

variable "private_azs" {
  type = list(string)
}
