variable "certificates" {
  type = map(object({
    type = string
    cert = string
    key  = string
  }))
}
