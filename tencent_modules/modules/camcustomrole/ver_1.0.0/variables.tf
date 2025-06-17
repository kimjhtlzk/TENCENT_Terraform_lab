variable "role_name" {
  type        = string
  description = "role_name"
}

variable "document" {
  type        = string
  description = "role json"
}

variable "console_login" {
  type        = bool
  description = "console_login"
  default = false
}

variable "description" {
  type        = string
  description = "description"
}

variable "session_duration" {
  type        = number
  description = "session_duration"
  default = "7200"
}

variable "policy_name" {
  type        = list(string)
  description = "policy_name"
  default = null
}
