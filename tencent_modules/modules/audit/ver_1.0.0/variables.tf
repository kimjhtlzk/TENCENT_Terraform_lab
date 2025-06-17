variable "audit_tracks" {
  description = "List of audit track configurations"
  type = list(object({
    name                  = string
    resource_type         = string
    event_names           = list(string)
    action_type           = string
    storage = object({
      storage_prefix = string
      storage_type   = string
    })
  }))
}