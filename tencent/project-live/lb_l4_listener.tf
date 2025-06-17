locals {
  tencent_l4 = {
    singapore = {
      clb-live-log-24224-listener = {
        target_clb = "clb-live-log"
        port       = 24224
        protocol   = "TCP"
      
        listener_certificate = {
          certificate_ssl_mode = "UNIDIRECTIONAL"
          certificate_id       = "KlAxlpGd"
          certificate_ca_id    = null
        }

        health_check = {
          health_check_type          = "TCP"
          health_check_port          = 24224
          health_check_switch        = true
          health_check_time_out      = 10
          health_check_interval_time = 60
          health_check_health_num    = 5
          health_check_unhealth_num  = 3
        }
        backend_instances = [
          {
            instance = "sdfsdf-live-log-t01"
            port     = 24224
            weight   = 10  ##가중치
          },
          {
            instance = "ssea-live-log-t02"
            port     = 24224
            weight   = 10  ##가중치
          },

        ]
      }

    }
  }
}


module "tencent_singapore_l4" {
  source   = "i-gitlab.co.com/common/tencent/clbl4listener"
  version  = "1.0.1"
  for_each = local.tencent_l4.singapore

  providers = {
    tencentcloud = tencentcloud.singapore
  }

  listener_name = each.key
  clb_id        = module.tencent_singapore_clb[each.value.target_clb].clb_id
  protocol      = each.value.protocol
  port          = each.value.port
  health_check  = each.value.health_check
  listener_certificate = each.value.listener_certificate
  backend_instances = [
    for instance in each.value.backend_instances : {
      instance_id = module.tencent_singapore_cvm[instance.instance].instance_id
      port        = instance.port
      weight      = instance.weight
    }
  ]

  depends_on = [module.tencent_singapore_cvm, module.tencent_singapore_clb]
}


module "tencent_frankfurt_l4" {
  source   = "i-gitlab.co.com/common/tencent/clbl4listener"
  version  = "1.0.1"
  for_each = local.tencent_l4.frankfurt

  providers = {
    tencentcloud = tencentcloud.frankfurt
  }

  listener_name = each.key
  clb_id        = module.tencent_frankfurt_clb[each.value.target_clb].clb_id
  protocol      = each.value.protocol
  port          = each.value.port
  health_check  = each.value.health_check
  listener_certificate = each.value.listener_certificate
  backend_instances = [
    for instance in each.value.backend_instances : {
      instance_id = module.tencent_frankfurt_cvm[instance.instance].instance_id
      port        = instance.port
      weight      = instance.weight
    }
  ]

  depends_on = [module.tencent_frankfurt_cvm, module.tencent_frankfurt_clb]
}


