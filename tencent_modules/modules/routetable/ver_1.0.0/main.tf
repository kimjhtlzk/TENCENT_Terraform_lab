## vpc에 종속 되는 rtt를 만듬
resource "tencentcloud_route_table" "rtt" {
  name   = var.route_table_name
  vpc_id = var.vpc
  tags = {
    Name = var.route_table_name
  }
}

resource "tencentcloud_route_table_entry" "instance" {
  for_each = { for rule in var.rule : rule.cidr_block => rule }

  route_table_id         = tencentcloud_route_table.rtt.id
  destination_cidr_block = each.value.cidr_block
  next_type              = each.value.resource_type
  next_hub               = each.value.next_hub
}

resource "tencentcloud_route_table_association" "rtt_association" {
  count           = length(var.asso_subnets)

  subnet_id      = var.asso_subnets[count.index]
  route_table_id = tencentcloud_route_table.rtt.id
  
} 