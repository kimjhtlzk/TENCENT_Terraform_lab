resource "tencentcloud_eip" "eip" {
  name                       = var.eip_name
  internet_max_bandwidth_out = var.eip_internet_max_bandwidth_out
} 