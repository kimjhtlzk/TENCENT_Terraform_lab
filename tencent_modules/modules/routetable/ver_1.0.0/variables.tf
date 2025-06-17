variable "route_table_name" {
    default = null
}
variable "vpc" {
    default = null
}
variable "rule" {
  type = list(object({
    cidr_block    = string
    resource_type = string
    next_hub   = string
  }))
}

variable "asso_subnets" {
  type    = list(string)
}