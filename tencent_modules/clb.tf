locals {
  tencent_clb = {
    seoul = {
      ihanni-test-lcuclb2 = {
        vpc            = "vpc-ihanni-test"
        network_type   = "INTERNAL" ## OPEN or INTERNAL
        security_groups = [
          "basic-seoul-live-sg"
        ]
        load_balancer_pass_to_target = "true" ## CLB의 backend 트래픽은 SG를 통과
        internet_bandwidth_max_out   = "100"  ## max 2G Mpbs

        ## log 관련 / cls에 기본 토픽 아래로 셋팅 됨
        create_clb_log = false
        #clb_log_set_period    = 7
        #clb_log_topic_name    = "CLB-c2v-groupnull"

        # 추가된 옵션들
        eip_address    = "ihanni-external" ## 1.0.2 사용 안할때는 라인자체를 삭제하거나 null로 입력
        subnet         = "c2v-ihanni-test1" ## 1.0.2 사용 안할때는 라인자체를 삭제하거나 null로 입력, 사용할 경우 INTERNAL일 경우만 사용
        sla_type       = "clb.c2.medium" ## 1.0.2 사용 안할때는 라인자체를 삭제하거나 null로 입력 (최저스펙 "clb.c2.medium")
      }
    }
  }
}

## official_module based custom_module
module "tencent_seoul_clb" {
  source                        = "/Users/ihanni/Desktop/my_empty/my_drive/vsc/test_tencent/modules/clb/ver_1.0.2"

  providers = {
    tencentcloud = tencentcloud.seoul
  }

  for_each                     = local.tencent_clb.seoul
  clb_name                     = each.key
  network_type                 = each.value.network_type
  vpc_id                       = module.tencent_seoul_vpc[each.value.vpc].vpc_id
  security_groups              = length(each.value.security_groups) > 0 ? [for sg_name in each.value.security_groups : module.tencent_seoul_sg[sg_name].security_group_id] : null
  load_balancer_pass_to_target = each.value.load_balancer_pass_to_target
  internet_bandwidth_max_out   = each.value.internet_bandwidth_max_out
  create_clb_log               = each.value.create_clb_log
  clb_log_set_period           = each.value.create_clb_log ? each.value.clb_log_set_period : null
  clb_log_topic_name           = each.value.create_clb_log ? each.value.clb_log_topic_name : null

  # 추가된 옵션들
  sla_type = try(each.value.sla_type, null)
  eip_address_id = try(each.value.eip_address, null) != null ? module.tencent_seoul_eip[each.value.eip_address].eip_id : null
  subnet_id = try(each.value.subnet, null) != null && each.value.network_type == "INTERNAL" ? module.tencent_seoul_vpc[each.value.vpc].subnets[each.value.subnet].id : null
}
