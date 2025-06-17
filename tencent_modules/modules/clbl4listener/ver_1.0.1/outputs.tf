# clb outputs
output "clb_id" {
  description = "Id of CLB instance."
  value       = local.clb_id
}

# clb listener outputs
output "listener_id" {
  description = "Id of CLB listener."
  value       = local.listener_id
}

output "listener_name" {
  description = "Name of the CLB listener."
  value       = length(local.this_listener_info) > 0 ? local.this_listener_info[0].listener_name : ""
}

output "port" {
  description = "Port of the CLB listener."
  value       = length(local.this_listener_info) > 0 ? local.this_listener_info[0].port : null
}

output "protocol" {
  description = "Type of protocol within the listener."
  value       = length(local.this_listener_info) > 0 ? local.this_listener_info[0].protocol : ""
}

# attachment outputs
output "backend_instances" {
  description = "Information of the backends to be attached."
  value       = length(local.targets) > 0 ? local.backend_instances_read : []
}