# clb instance variables
variable "clb_id" {
  description = "Id of the CLB."
  type        = string
}

# clb-listener variables
variable "listener_id" {
  description = "Id of the CLB listener"
  type        = string
  default     = ""
}

variable "listener_name" {
  description = "Name of the CLB listener, and available values can only be Chinese characters, English letters, numbers, underscore and hyphen '-'."
  type        = string
  default     = "tf-modules-clb-listener"
}

variable "port" {
  description = "Port of the CLB listener."
  type        = number
  default     = null
}

variable "protocol" {
  type        = string
  description = "Type of protocol within the listener, and available values are 'TCP' and 'UDP'."
  default     = null
}

variable "health_check" {
  type = object({
    health_check_type          = string
    health_check_switch        = bool
    health_check_time_out      = number
    health_check_interval_time = number
    health_check_health_num    = number
    health_check_unhealth_num  = number
  })
  description = "The CLB layer4 listener health check settings. Supported fields are `health_check_switch`, `health_check_time_out`, `health_check_interval_time`, `health_check_health_num` and `health_check_unhealth_num`."
  default = {
    health_check_type          = "TCP"
    health_check_switch        = false
    health_check_time_out      = 2
    health_check_interval_time = 5
    health_check_health_num    = 3
    health_check_unhealth_num  = 3
  }
}

variable "session_expire_time" {
  type        = number
  description = "Time of session persistence within the CLB listener. NOTES: Available when scheduler is specified as 'WRR'."
  default     = null
}

variable "scheduler" {
  type        = string
  description = "Scheduling method of the CLB listener, and available values are 'WRR' and 'LEAST_CONN'. The default is 'WRR'."
  default     = "WRR"
}

# clb-attachment variables
variable "backend_instances" {
  type = list(object({
    instance_id = string
    port        = number
    weight      = number
  }))
  description = "Information of the backends to be attached. if omitted, will create CLB listener only without the attachment."
  default     = []
}

## certification variables
variable "listener_certificate" {
  type = object({
    certificate_ssl_mode = string
    certificate_id       = string
    certificate_ca_id    = string
  })
  description = "The CLB layer4 listener certificate settings. Supported fields are `certificate_ssl_mode`, `certificate_id`, `certificate_ca_id` and `sni_switch`. NOTES: Only supports listeners of 'TLS'."
  default = {
    certificate_ssl_mode = null
    certificate_id       = null
    certificate_ca_id    = null
  }
}