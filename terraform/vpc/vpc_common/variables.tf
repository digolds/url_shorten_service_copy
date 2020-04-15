variable "cidr_block" {
  type    = string
  default = "10.32.0.0/16"
}

variable "vpc_name" {
  type = string
}

variable "newbits_for_lambda" {
  type = number
}

variable "newbits_for_cache" {
  type = number
}

variable "port_memcache" {
  type    = number
  default = 11211
}
