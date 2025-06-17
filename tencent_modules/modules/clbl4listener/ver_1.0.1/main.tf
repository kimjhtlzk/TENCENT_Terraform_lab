resource "tencentcloud_clb_listener" "this" {
  count = var.listener_id == "" ? 1 : 0
 
  clb_id                     = var.clb_id
  listener_name              = var.listener_name
  port                       = var.port
  protocol                   = var.protocol
  health_check_type          = lookup(var.health_check, "health_check_type", "TCP")
  health_check_port          = lookup(var.health_check, "health_check_port", 80)
  health_check_switch        = lookup(var.health_check, "health_check_switch", false)
  health_check_time_out      = lookup(var.health_check, "health_check_time_out", 2)
  health_check_interval_time = lookup(var.health_check, "health_check_interval_time", 5)
  health_check_health_num    = lookup(var.health_check, "health_check_health_num", 3)
  health_check_unhealth_num  = lookup(var.health_check, "health_check_unhealth_num", 3)
  # health_check_http_version  = "HTTP/1.1"
  session_expire_time        = var.scheduler == "WRR" ? var.session_expire_time : null
  ## TLS 지원용도 certificate_id 추가(ver_1.0.0)
  certificate_ssl_mode = var.protocol == "TCP_SSL" ? lookup(var.listener_certificate, "certificate_ssl_mode", null) : null
  certificate_id       = var.protocol == "TCP_SSL" ? lookup(var.listener_certificate, "certificate_id", null) : null
  certificate_ca_id    = var.protocol == "TCP_SSL" && lookup(var.listener_certificate, "certificate_ssl_mode") == "MUTUAL" ? lookup(var.listener_certificate, "certificate_ca_id") : null
  scheduler                  = var.scheduler
}

resource "tencentcloud_clb_attachment" "this" {
  count = length(var.backend_instances) > 0 ? 1 : 0

  clb_id      = local.clb_id
  listener_id = local.listener_id
  dynamic "targets" {
    for_each = local.backend_instances
    content {
      instance_id = lookup(targets.value, "instance_id")
      port        = lookup(targets.value, "port")
      weight      = lookup(targets.value, "weight")
    }
  }
}

data "tencentcloud_clb_listeners" "this" {
  clb_id      = local.clb_id
  listener_id = local.listener_id
}

locals {
  backend_instances = flatten([
    for _, obj in var.backend_instances : {
      instance_id = lookup(obj, "instance_id")
      port        = lookup(obj, "port")
      weight      = lookup(obj, "weight", 10)
    }
  ])

  this_listener_info = data.tencentcloud_clb_listeners.this.listener_list
  targets            = concat(tencentcloud_clb_attachment.this.*.targets, [{}])[0]
  clb_id             = var.clb_id
  ## 공식모듈 deprecated 된 선언방식 사용, 50 listener_id 수정(ver_1.0.0)
  listener_id        = var.listener_id != "" ? var.listener_id : concat(tencentcloud_clb_listener.this.*.listener_id, [""])[0]
  backend_instances_read = flatten([
    for _, obj in local.targets : {
      instance_id = lookup(obj, "instance_id")
      port        = lookup(obj, "port")
      weight      = lookup(obj, "weight")
    }
  ])
}