resource "tencentcloud_eip" "eip" {
  count = var.eip == "true" ? 1 : 0
  name  = "eip-${var.ngw_name}-ngw"
  internet_max_bandwidth_out = "100"
}


resource "tencentcloud_nat_gateway" "ngw" {
  name             = var.ngw_name
  vpc_id = var.vpc
  assigned_eip_set = var.eip == "true" ? tencentcloud_eip.eip.*.public_ip : [var.eip]
  bandwidth        = var.nat_gateway_bandwidth
  max_concurrent   = var.nat_gateway_concurrent

  depends_on        = [tencentcloud_eip.eip]
} 