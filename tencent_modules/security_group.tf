locals {
  tencent_sg = {
    seoul = {
      dev-qasubent-common-sg = {

        #inbound
        ingress_for_lite_rule = [ # 주석 설명 필수
          # 기본 내부통신정책 (서브넷)
          "ACCEPT#10.35.10.0/24#ALL#ALL"
        ]

        #outbound
        egress_for_lite_rule = [ # 주석 설명 필수
          # 기본 내부통신정책 (서브넷)
          "ACCEPT#10.35.10.0/24#ALL#ALL"

        ]
      }
      basic-seoul-live-sg = {

        #inbound
        ingress_for_lite_rule = [ # 주석 설명 필수
          # vpn

        ]

        #outbound
        egress_for_lite_rule = [ # 주석 설명 필수

          "DROP#0.0.0.0/0#ALL#ALL"

        ]
      }
      basic-seoul-live-db-sg = {

        #inbound
        ingress_for_lite_rule = [ # 주석 설명 필수

        ]

        #outbound
        egress_for_lite_rule = [ # 주석 설명 필수

        ]
      }
    }
  }
}

## official_module based custom_module
module "tencent_seoul_sg" {
  ## 공식모듈 사용
  source   = "i-gitlab.cs.com/common/tencent/securitygroup"
  for_each = local.tencent_sg.seoul

  providers = {
    tencentcloud = tencentcloud.seoul
  }

  name                  = each.key
  description           = try(each.value.description, each.key)
  create_lite_rule      = try(each.value.create_lite_rule, true)
  ingress_for_lite_rule = each.value.ingress_for_lite_rule
  egress_for_lite_rule  = each.value.egress_for_lite_rule
}