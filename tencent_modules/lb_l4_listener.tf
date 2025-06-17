locals {
  tencent_l4 = {
    seoul = {
      clb-layer4-listener = {
        target_clb = "CLB-c2v-test"
        port       = 11111
        protocol   = "TCP_SSL"
      
        listener_certificate = {
          certificate_ssl_mode = "UNIDIRECTIONAL"
          certificate_id       = "6sdfsdeWxcK"
          certificate_ca_id    = null
        }

        health_check = {
          health_check_type          = "HTTP"
          health_check_switch        = true
          health_check_time_out      = 10
          health_check_interval_time = 60
          health_check_health_num    = 5
          health_check_unhealth_num  = 3
        }
        backend_instances = [
          {
            instance = "test-vm"
            port     = 8899
            weight   = 50
          },
        ]
      }
    }
  }
}

## official_module based custom_module
module "tencent_seoul_l4" {
  source = "./modules/lb_l4_listener/ver_1.0.0"
  for_each = local.tencent_l4.seoul

  providers = {
    tencentcloud = tencentcloud.seoul
  }

  listener_name = each.key
  clb_id        = module.tencent_seoul_clb[each.value.target_clb].clb_id
  protocol      = each.value.protocol
  port          = each.value.port
  health_check  = each.value.health_check
  listener_certificate = each.value.listener_certificate
  backend_instances = [
    for instance in each.value.backend_instances : {
      instance_id = module.tencent_seoul_cvm[instance.instance].instance_id
      port        = instance.port
      weight      = instance.weight
    }
  ]

  depends_on = [module.tencent_seoul_cvm, module.tencent_seoul_clb]
}