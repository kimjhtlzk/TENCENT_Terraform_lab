variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "cpu_core_count" {
  description = "CPU core count used to query supported available zones."
  default     = 1
}

variable "memory_size" {
  description = "Memory size used to query supported available zones."
  default     = 2
}

variable "gpu_core_count" {
  description = "GPU core count used to query supported available zones."
  default     = 0
}

variable "vpc_id" {
  description = "The vpc id used to launch resources."
  default     = ""
}

variable "vpc_name" {
  description = "The vpc name used to launch a new vpc when 'vpc_id' is not specified."
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  default     = "172.16.0.0/16"
}

variable "vpc_is_multicast" {
  description = "Specify the vpc is multicast when 'vpc_id' is not specified."
  default     = true
}

variable "vpc_dns_servers" {
  description = "Specify the vpc dns servers when 'vpc_id' is not specified."
  type        = list(string)
  default     = []
}

variable "vpc_tags" {
  description = "Additional tags for the vpc."
  type        = map(string)
  default     = {}
}

variable "subnet_name" {
  description = "Specify the subnet name when 'vpc_id' is not specified."
  default     = "subnet"
}

variable "subnet_cidrs" {
  description = "Specify the subnet cidr blocks when 'vpc_id' is not specified."
  type        = list(string)
  default     = []
}

variable "subnet_is_multicast" {
  description = "Specify the subnet is multicast when 'vpc_id' is not specified."
  default     = true
}

variable "subnet_tags" {
  description = "Additional tags for the subnet."
  type        = map(string)
  default     = {}
}

variable "availability_zones" {
  description = "List of available zones to launch resources."
  type        = list(string)
  default     = []
}

variable "route_table_id" {
  description = "The route table id of router table in the specified vpc."
  default     = ""
}

variable "destination_cidrs" {
  description = "List of destination CIDR blocks of router table in the specified VPC."
  type        = list(string)
  default     = []
}

variable "next_hub" {
  description = "List of next hop gateway id of router table in the specified vpc."
  type        = list(string)
  default     = []
}

variable "number_format" {
  description = "The number format used to output."
  default     = "%02d"
}

variable "route_table_tags" {
  description = "Additional tags for the route table."
  type        = map(string)
  default     = {}
}

/* enable ACL to subnets */
variable "manage_network_acl" {
  description = "Should be true to adopt and manage Network ACL for subnets"
  type        = bool
  default     = false
}

variable "network_acl_name" {
  description = "Name to be used on Network ACL"
  type        = string
  default     = ""
}

variable "network_acl_tags" {
  description = "Additional tags for the Network ACL"
  type        = map(string)
  default     = {}
}

variable "network_acl_ingress" {
  description = "List of strings of ingress rules to set on the Network ACL, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`"
  type        = list(string)

  default = null
}

variable "network_acl_egress" {
  description = "List of strings of egress rules to set on the Network ACL, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`"
  type        = list(string)

  default = [
    "ACCEPT#0.0.0.0/0#ALL#ALL"
  ]
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for vpc."
  type        = bool
  default     = false
}

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

variable "nat_gateway_tags" {
  description = "Additional tags for the NAT gateway"
  type        = map(string)
  default     = {}
}

variable "nat_public_ips" {
  description = "List of EIPs to be used for `nat_gateway`"
  type        = list(string)
  default     = []
}

variable "subnets" {
  type = list(object({
    subnet_name         = string
    subnet_cidr         = string
    availability_zone   = string
  }))
}