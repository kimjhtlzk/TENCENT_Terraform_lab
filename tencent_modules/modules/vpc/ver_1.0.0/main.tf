resource "tencentcloud_vpc" "vpc" {
  name         = var.vpc_name
  cidr_block   = var.vpc_cidr
  is_multicast = var.vpc_is_multicast
  tags         = merge(var.tags, var.vpc_tags)
}

resource "tencentcloud_subnet" "subnet" {
  for_each = { for subnet in var.subnets : subnet.subnet_name => subnet }
  name              = each.value.subnet_name
  vpc_id            = tencentcloud_vpc.vpc.id
  cidr_block        = each.value.subnet_cidr
  availability_zone = each.value.availability_zone

  tags              = merge(var.tags, var.subnet_tags)

  depends_on = [tencentcloud_vpc.vpc]
} 