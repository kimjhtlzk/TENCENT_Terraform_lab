locals {
  this_clb_info      = data.tencentcloud_clb_instances.this.clb_list
  clb_id             = tencentcloud_clb_instance.this.id
  log_set_id         = var.log_set_id == "" && var.create_clb_log ? tencentcloud_clb_log_set.set[0].id : var.log_set_id
  log_topic_id       = var.log_topic_id == "" && var.create_clb_log ? tencentcloud_clb_log_topic.topic[0].id : var.log_topic_id
  # listener_resources = tencentcloud_clb_listener.listener
  # rule_resources     = tencentcloud_clb_listener_rule.listener_rule
}

resource "tencentcloud_clb_instance" "this" {
  project_id      = var.project_id
  clb_name        = var.clb_name
  tags            = var.clb_tags
  network_type    = var.network_type
  vpc_id          = var.vpc_id == null ? 0 : var.vpc_id
  subnet_id       = var.vpc_id != null && var.subnet_id != null ? var.subnet_id : null
  security_groups = var.security_groups

  log_set_id   = local.log_set_id
  log_topic_id = local.log_topic_id

  address_ip_version           = var.network_type == "OPEN" ? var.address_ip_version : null
  bandwidth_package_id         = var.network_type == "OPEN" ? var.bandwidth_package_id : null
  internet_bandwidth_max_out   = var.network_type == "OPEN" ? var.internet_bandwidth_max_out : null
  internet_charge_type         = var.network_type == "OPEN" ? var.internet_charge_type : null
  load_balancer_pass_to_target = var.load_balancer_pass_to_target

  sla_type = var.sla_type != null ? var.sla_type : null

  dynamic "snat_ips" {
    for_each = var.snat_ips
    content {
      subnet_id = snat_ips.value.subnet_id
      ip        = snat_ips.value.ip
    }
  }
  snat_pro                  = var.snat_pro
  target_region_info_region = var.target_region_info_region
  target_region_info_vpc_id = var.target_region_info_vpc_id

  eip_address_id = var.eip_address_id != null ? var.eip_address_id : null
}



data "tencentcloud_clb_instances" "this" {
  clb_id = local.clb_id
}

resource "tencentcloud_clb_log_set" "set" {
  count  = var.log_set_id == "" && var.create_clb_log ? 1 : 0
  period = var.clb_log_set_period
}

resource "tencentcloud_clb_log_topic" "topic" {
  count      = var.log_topic_id == "" && var.create_clb_log ? 1 : 0
  log_set_id = local.log_set_id
  topic_name = var.clb_log_topic_name
}
 
# resource "tencentcloud_clb_redirection" "clb_redirection" {
#   count                   = var.create_clb_redirections ? length(var.clb_redirections) : 0
#   clb_id                  = tencentcloud_clb_instance.this.id
#   target_listener_id      = local.rule_resources[var.clb_redirections[count.index].target_listener_rule_index].listener_id
#   target_rule_id          = local.rule_resources[var.clb_redirections[count.index].target_listener_rule_index].rule_id
#   delete_all_auto_rewrite = lookup(var.clb_redirections[count.index], "delete_all_auto_rewrite", null)
#   is_auto_rewrite         = lookup(var.clb_redirections[count.index], "is_auto_rewrite", null)
#   source_listener_id      = lookup(var.clb_redirections[count.index], "source_listener_rule_index", null) != null ? local.rule_resources[var.clb_redirections[count.index].source_listener_rule_index].listener_id : null
#   source_rule_id          = lookup(var.clb_redirections[count.index], "source_listener_rule_index", null) != null ? local.rule_resources[var.clb_redirections[count.index].source_listener_rule_index].rule_id : null
# } 