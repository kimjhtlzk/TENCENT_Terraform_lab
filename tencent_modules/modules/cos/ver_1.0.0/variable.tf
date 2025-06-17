variable "cos_name" {
  type = string
}

variable "acceleration_enable" {
  type = bool
}

variable "acl" {
  type = string
}

variable "log_enable" {
  type = bool
}

variable "versioning_enable" {
  type = bool
}

variable "force_clean" {
  type = bool
}

variable "lifecycle_rules" {
  default     = []
}
