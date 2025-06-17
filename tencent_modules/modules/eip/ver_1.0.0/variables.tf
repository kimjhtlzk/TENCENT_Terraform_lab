variable "region" {
  default = ""
}

//eip
variable "eip_name" {
  default = ""
}

variable "eip_internet_max_bandwidth_out" {
  default = 100
}

variable "eip_tags" {
  type    = map(string)
  default = {}
}