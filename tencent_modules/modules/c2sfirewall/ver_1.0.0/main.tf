locals {
  security_groups = {
     c2s-common-sg = {

        #inbound
        ingress_for_lite_rule = [ # 주석 설명 필수
        ]

        #outbound
        egress_for_lite_rule = [ # 주석 설명 필수
          # basic outbound
          "ACCEPT#0.0.0.0/0#80#TCP",
          "DROP#0.0.0.0/0#ALL#ALL",
        ]
      }
  }
}

module "security_groups" {
  for_each = local.security_groups

  source = "i-gitlab.c.com/common/tencent/securitygroup"

  name                  = each.key
  description           = try(each.value.description, each.key)
  create_lite_rule      = try(each.value.create_lite_rule, true)
  ingress_for_lite_rule = each.value.ingress_for_lite_rule
  egress_for_lite_rule  = each.value.egress_for_lite_rule
}

output "security_group_ids" {
  value = tencentcloud_security_group.security_group_ids  # 실제 보안 그룹 리소스의 ID 값
}