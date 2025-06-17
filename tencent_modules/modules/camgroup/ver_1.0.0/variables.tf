variable "group_name" {
  type        = string
  default     = null
  description = "group name"
}

variable "user_name" {
  type        = list(string)
  default     = null
  description = "user name"
}

variable "policy" {
  #type        = list(string)
  default     = null
  description = "policy name"
}