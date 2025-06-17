resource "tencentcloud_clb_listener" "this" {
  count = var.listener_id == "" ? 1 : 0

  clb_id               = var.clb_id
  listener_name        = var.listener_name
  port                 = var.port
  protocol             = var.protocol
  certificate_ssl_mode = var.protocol == "HTTPS" ? lookup(var.listener_certificate, "certificate_ssl_mode", null) : null
  certificate_id       = var.protocol == "HTTPS" ? lookup(var.listener_certificate, "certificate_id", null) : null
  certificate_ca_id    = var.protocol == "HTTPS" && lookup(var.listener_certificate, "certificate_ssl_mode") == "MUTUAL" ? lookup(var.listener_certificate, "certificate_ca_id") : null
  sni_switch           = var.protocol == "HTTPS" ? lookup(var.listener_certificate, "sni_switch", false) : null
}

resource "tencentcloud_clb_listener_rule" "this" {
  count = length(var.tencent_l7_rules)

  clb_id      = var.clb_id
  listener_id = local.listener_id
  domain      = var.tencent_l7_rules[count.index].domain
  url         = var.tencent_l7_rules[count.index].url

  health_check_port = var.tencent_l7_rules[count.index].health_check != null && lookup(var.tencent_l7_rules[count.index].health_check, "health_check_port", null) != null ? lookup(var.tencent_l7_rules[count.index].health_check, "health_check_port", 443) : null
  health_check_type          = lookup(var.tencent_l7_rules[count.index].health_check, "health_check_type", "TCP")
  health_check_switch        = lookup(var.tencent_l7_rules[count.index].health_check, "health_check_switch", false)
  health_check_interval_time = lookup(var.tencent_l7_rules[count.index].health_check, "health_check_interval_time", 5)
  health_check_health_num    = lookup(var.tencent_l7_rules[count.index].health_check, "health_check_health_num", 3)
  health_check_unhealth_num  = lookup(var.tencent_l7_rules[count.index].health_check, "health_check_unhealth_num", 3)
  health_check_http_code     = lookup(var.tencent_l7_rules[count.index].health_check, "health_check_http_code", 31)
  health_check_http_path     = lookup(var.tencent_l7_rules[count.index].health_check, "health_check_http_path", null)
  health_check_http_domain   = lookup(var.tencent_l7_rules[count.index].health_check, "health_check_http_domain", null)
  health_check_http_method   = lookup(var.tencent_l7_rules[count.index].health_check, "health_check_http_method", "HEAD")

  certificate_ssl_mode = try(var.tencent_l7_rules[count.index].rule_certificate["certificate_ssl_mode"], null)
  certificate_id       = try(var.tencent_l7_rules[count.index].rule_certificate["certificate_id"], null)
  certificate_ca_id    = try(var.tencent_l7_rules[count.index].rule_certificate["certificate_ca_id"], null)

  session_expire_time = var.tencent_l7_rules[count.index].session_expire_time
  scheduler           = var.tencent_l7_rules[count.index].scheduler
  forward_type        = var.tencent_l7_rules[count.index].forward_type
}


resource "tencentcloud_clb_attachment" "this" {
  count = length(var.tencent_l7_rules)

  depends_on = [tencentcloud_clb_listener_rule.this]

  clb_id      = var.clb_id
  listener_id = local.listener_id
  rule_id     = tencentcloud_clb_listener_rule.this[count.index].rule_id

  dynamic "targets" {
    for_each = flatten([
      for b in var.tencent_l7_rules[count.index].backend_instances : [
        for i in b.instance : {
          instance_id = i
          port        = b.port
          weight      = b.weight
        }
      ]
    ])
    content {
      instance_id = targets.value.instance_id
      port        = targets.value.port
      weight      = targets.value.weight
    }
  }
}

data "tencentcloud_clb_listeners" "this" {
  clb_id      = local.clb_id
  listener_id = local.listener_id
}

data "tencentcloud_clb_listener_rules" "this" {
  clb_id      = local.clb_id
  listener_id = local.listener_id
  rule_id     = var.rule_id
}

locals {
  clb_id           = var.clb_id
  listener_id      = var.listener_id != "" ? var.listener_id : try(
    tencentcloud_clb_listener.this[0].listener_id,
    null
  )
  rule_id          = var.rule_id
  this_listener_info = data.tencentcloud_clb_listeners.this.listener_list
  this_rule_info     = data.tencentcloud_clb_listener_rules.this.rule_list
}