variable "nat_gateway_bandwidth" {
  description = "bandwidth of NAT Gateway"
  type        = number
  default     = 100
}

variable "nat_gateway_concurrent" {
  description = "bandwidth of NAT Gateway"
  type        = number
  default     = 1000000
}

variable "ngw_name" {
    default = null
}
variable "eip" {
    default = null
}

variable "vpc" {
    default = null
}

variable "subnet" {
    default = null
}
variable "join_subnet" {
    default = null
}
variable "rt_table_cidr" {
    default = null
}
