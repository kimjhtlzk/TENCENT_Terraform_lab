locals {
  tencent_l7 = {
    seoul = {
      clb-layer7-listener = {
        target_clb = "ihanni-test-lcuclb"
        port       = 443
        protocol   = "HTTPS"

        listener_certificate = {
          certificate_ssl_mode = "UNIDIRECTIONAL"
          certificate_id       = "KDFSFAQTCm"
          certificate_ca_id    = null
          sni_switch           = false
        }

        tencent_l7_rules = [ ## 1.0.1 forwarding_rule 다중 생성
          {
            domain = "foo.net"
            url    = "/bar"

            health_check = {
              health_check_port          = null  ## 1.0.2 사용 안할때는 라인자체를 삭제하거나 null로 입력
              health_check_type          = "TCP" 
              health_check_switch        = true
              health_check_interval_time = 60
              health_check_health_num    = 5
              health_check_unhealth_num  = 3
              health_check_http_code     = 2
              health_check_http_path     = "/"
              health_check_http_domain   = "foo.net"
              health_check_http_method   = "GET"
            }

            session_expire_time = 30
            scheduler           = "WRR" ## weighted RR
            forward_type        = "HTTPS"

            backend_instances = [
              {
                instance = [ "test-vm" ]
                port     = 9001
                weight   = 50  ##가중치
              }
            ]
          }
        ]

      }
    }
  }
}

## official_module based custom_module
module "tencent_seoul_l7" {
  source = "/Users/ihanni/Desktop/my_empty/my_drive/vsc/test_tencent/modules/clbl7listener/ver_1.0.2"

  for_each = local.tencent_l7.seoul

  providers = {
    tencentcloud = tencentcloud.seoul
  }

  listener_name        = each.key
  clb_id               = module.tencent_seoul_clb[each.value.target_clb].clb_id
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
            for i in instance.instance : module.tencent_seoul_cvm[i].instance_id
          ]
          port   = instance.port
          weight = instance.weight
        }
      ]
    }
  ]

  depends_on = [module.tencent_seoul_cvm, module.tencent_seoul_clb]
}
