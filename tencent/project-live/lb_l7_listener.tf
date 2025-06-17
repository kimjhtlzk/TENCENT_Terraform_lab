locals {
  tencent_l7 = {
    singapore = {
      clb-live-start-443-listener = {
        target_clb = "clb-live-start"
        port       = 443
        protocol   = "HTTPS"

        listener_certificate = {
          certificate_ssl_mode = "UNIDIRECTIONAL"
          certificate_id       = "OEOjhSEt"
          certificate_ca_id    = null
          sni_switch           = false
        }

        tencent_l7_rules = [ ## 1.0.1 forwarding_rule 다중 생성
          { ## forwarding rule 1
            domain = "tlive-asdasd-u.cn"
            url    = "/"

            health_check = {
              health_check_port          = 80
              health_check_type          = "TCP"
              health_check_switch        = true
              health_check_interval_time = 60
              health_check_health_num    = 5
              health_check_unhealth_num  = 3
              health_check_http_code     = 2
              health_check_http_path     = "/healthcheck.html"
              health_check_http_domain   = "tlive-asdasda-start.qpyou.cn"
              health_check_http_method   = "GET"
            }

            session_expire_time = 30
            scheduler           = "WRR" ## weighted RR
            forward_type        = "HTTPS"

            backend_instances = [
              {
                instance =  [ "asdasd-live-start-t01", "asdasda-live-start-t02" ]
                port     = 24001
                weight   = 10  ##가중치
              },

            ]
          },

        ]
      }
   
    }


  }
}


module "tencent_singapore_l7" {
  source = "i-gitlab.co.com/common/tencent/clbl7listener"
  for_each = local.tencent_l7.singapore

  providers = {
    tencentcloud = tencentcloud.singapore
  }

  listener_name        = each.key
  clb_id               = module.tencent_singapore_clb[each.value.target_clb].clb_id
  protocol             = each.value.protocol
  port                 = each.value.port
  listener_certificate = each.value.listener_certificate

  tencent_l7_rules = [
    for rule in each.value.tencent_l7_rules : {
      domain            = rule.domain
      url               = rule.url
      health_check      = rule.health_check
      session_expire_time = rule.session_expire_time
      scheduler        = rule.scheduler
      forward_type     = rule.forward_type

      backend_instances = [
        for instance in rule.backend_instances : {
          instance = [
            for i in instance.instance : module.tencent_singapore_cvm[i].instance_id
          ]
          port   = instance.port
          weight = instance.weight
        }
      ]
    }
  ]

  depends_on = [module.tencent_singapore_cvm, module.tencent_singapore_clb]
}



module "tencent_frankfurt_l7" {
  source = "i-gitlab.co.com/common/tencent/clbl7listener"

  for_each = local.tencent_l7.frankfurt

  providers = {
    tencentcloud = tencentcloud.frankfurt
  }

  listener_name        = each.key
  clb_id               = module.tencent_frankfurt_clb[each.value.target_clb].clb_id
  protocol             = each.value.protocol
  port                 = each.value.port
  listener_certificate = each.value.listener_certificate

  tencent_l7_rules = [
    for rule in each.value.tencent_l7_rules : {
      domain            = rule.domain
      url               = rule.url
      health_check      = rule.health_check
      session_expire_time = rule.session_expire_time
      scheduler        = rule.scheduler
      forward_type     = rule.forward_type

      backend_instances = [
        for instance in rule.backend_instances : {
          instance = [
            for i in instance.instance : module.tencent_frankfurt_cvm[i].instance_id
          ]
          port   = instance.port
          weight = instance.weight
        }
      ]
    }
  ]

  depends_on = [module.tencent_frankfurt_cvm, module.tencent_frankfurt_clb]
}





