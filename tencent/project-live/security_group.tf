locals {
  tencent_sg = {
    singapore = {
      live-log-sg = {
        description = "live-log-sg"

        ##간략화된 rule 사용 여부
        create_lite_rule = "true"
        #inbound
        ingress_for_lite_rule = [

        ]
        #outbound
        egress_for_lite_rule = [

        ]
      }

      lb-live-log-sg = {
        description = "lb-live-log-sg"

        ##간략화된 rule 사용 여부
        create_lite_rule = "true"
        #inbound
        ingress_for_lite_rule = [
          "ACCEPT#0.0.0.0/0#24224#TCP", # 서비스
        ]
        #outbound
        egress_for_lite_rule = []
      }
      lb-live-gateway-sg = {
        description = "lb-live-gateway-sg"

        ##간략화된 rule 사용 여부
        create_lite_rule = "true"
        #inbound
        ingress_for_lite_rule = [
          "ACCEPT#0.0.0.0/0#10000#TCP", # 서비스
        ]
        #outbound
        egress_for_lite_rule = []
      }
      lb-live-start-sg = {
        description = "lb-live-start-sg"

        ##간략화된 rule 사용 여부
        create_lite_rule = "true"
        #inbound
        ingress_for_lite_rule = [
          "ACCEPT#0.0.0.0/0#443#TCP", # 서비스
        ]
        #outbound
        egress_for_lite_rule = []
      }

      live-wassubnet-common-sg = {
        description = "live-wassubnet-common-sg"

        ##간략화된 rule 사용 여부
        create_lite_rule = "true"

        #inbound
        ingress_for_lite_rule = [ # 주석 설명 필수
          "ACCEPT#10.39.10.0/24#ALL#ALL", # was 서브넷 내부통신
          
        ]

        #outbound
        egress_for_lite_rule = [ # 주석 설명 필수


        ]
      }
      live-midsubnet-common-sg = {
        description = "live-midsubnet-common-sg"

        ##간략화된 rule 사용 여부
        create_lite_rule = "true"

        #inbound
        ingress_for_lite_rule = [ # 주석 설명 필수

          
        ]

        #outbound
        egress_for_lite_rule = [ # 주석 설명 필수


        ]
      }
      live-dbmastersubnet-common-sg = {
        description = "live-dbsubnet-common-sg"

        ##간략화된 rule 사용 여부
        create_lite_rule = "true"

        #inbound
        ingress_for_lite_rule = [ # 주석 설명 필수
          
        ]

        #outbound
        egress_for_lite_rule = [ # 주석 설명 필수

        ]
      }
      live-dbslavesubnet-common-sg = {
        description = "live-dbsubnet-common-sg"

        ##간략화된 rule 사용 여부
        create_lite_rule = "true"

        #inbound
        ingress_for_lite_rule = [ # 주석 설명 필수

          
        ]

        #outbound
        egress_for_lite_rule = [ # 주석 설명 필수


        ]
      }
      live-dbrollbacksubnet-common-sg = {
        description = "live-dbsubnet-common-sg"

        ##간략화된 rule 사용 여부
        create_lite_rule = "true"

        #inbound
        ingress_for_lite_rule = [ # 주석 설명 필수

          
        ]

        #outbound
        egress_for_lite_rule = [ # 주석 설명 필수

        ]
      }


      basic-frankfurt-live-sg = {
        description = "basic-frankfurt-live-sg"

        ##간략화된 rule 사용 여부
        create_lite_rule = "true"

        #inbound
        ingress_for_lite_rule = [ # 주석 설명 필수

        ]

        #outbound
        egress_for_lite_rule = [ # 주석 설명 필수
          # basic outbound
          "ACCEPT#0.0.0.0/0#80#TCP",

        ]
      }
      basic-frankfurt-live-db-sg = {
        description = "basic-frankfurt-live-db-sg"

        ##간략화된 rule 사용 여부
        create_lite_rule = "true"

        #inbound
        ingress_for_lite_rule = [ # 주석 설명 필수
          # vpn
        ]

        #outbound
        egress_for_lite_rule = [ # 주석 설명 필수
          # basic outbound
          # "ACCEPT#0.0.0.0/0#80#TCP", # <- db outbound 80 deny
          "ACCEPT#0.0.0.0/0#443#TCP",

        ]
      }


    }



  }
}




module "tencent_singapore_sg" {
  source   = "i-gitlab.co.com/common/tencent/securitygroup"
  for_each = local.tencent_sg.singapore

  providers = {
    tencentcloud = tencentcloud.singapore
  }

  name                  = each.key
  description           = each.value.description
  create_lite_rule      = each.value.create_lite_rule
  ingress_for_lite_rule = each.value.ingress_for_lite_rule
  egress_for_lite_rule  = each.value.egress_for_lite_rule
}
module "tencent_frankfurt_sg" {
  source   = "i-gitlab.co.com/common/tencent/securitygroup"
  for_each = local.tencent_sg.frankfurt

  providers = {
    tencentcloud = tencentcloud.frankfurt
  }

  name                  = each.key
  description           = each.value.description
  create_lite_rule      = each.value.create_lite_rule
  ingress_for_lite_rule = each.value.ingress_for_lite_rule
  egress_for_lite_rule  = each.value.egress_for_lite_rule
}