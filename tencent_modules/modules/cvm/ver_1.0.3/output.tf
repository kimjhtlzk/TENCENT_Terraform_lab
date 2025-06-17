output "instance_id" {
  description = "id of instance."
  value       = tencentcloud_instance.instance.id
}

output "instance_status" {
  description = "The state of instance."
  value       = tencentcloud_instance.instance.instance_status
}

output "public_ip" {
  description = "The public ip of instance."
  value       = tencentcloud_instance.instance.public_ip
}

output "private_ip" {
  description = "The private ip of instance."
  value       = tencentcloud_instance.instance.private_ip
}