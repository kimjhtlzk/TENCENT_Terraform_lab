output "vpc_id" {
  value = tencentcloud_vpc.vpc.id
}
output "subnets" {
  value = tencentcloud_subnet.subnet
}

output "availability_zones" {
  description = "The availability zones of instance type."
  value       = var.availability_zones
}

output "tags" {
  description = "A map of tags to add to all resources."
  value       = var.tags
}