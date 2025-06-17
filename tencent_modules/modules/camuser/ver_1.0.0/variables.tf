variable "iam_name" {
  type        = string
  description = "iam name"
}

variable "console_login" {
  type        = bool
  description = "console login"
}

variable "password_reset" {
  type        = bool
  description = "password_reset"
}

variable "sa" {
  type        = bool
  description = "service account MFA setting"
}

variable "email" {
  type        = string
  description = "email adress"
  default = "null"
}

variable "policy" {
  type        = list(string)
  description = "policy list"
}