locals {
  tencent_clb = {
    singapore = {
      clb-live-log = {
        vpc            = "vpc-sfsdfsd-live-singapore"
        network_type   = "INTERNAL" ## OPEN or INTERNAL
        subnet         = "public-live-subnet-az3-2"
        security_groups = [
          "lb-live-log-sg"
        ]
        load_balancer_pass_to_target = "true" ## CLB의 backend 트래픽은 SG를 통과
        internet_bandwidth_max_out   = null  ## max 2G Mpbs(2048)
        
        create_clb_log = false
      }

    }


  }
}


module "tencent_singapore_clb" {
  source                       = "i-gitlab.com.com/common/tencent/clb"

  providers = {
    tencentcloud = tencentcloud.singapore
  }

  for_each                     = local.tencent_clb.singapore
  clb_name                     = each.key
  network_type                 = each.value.network_type
  # master_zone_id             = each.value.master_zone_id
  vpc_id                       = module.tencent_singapore_vpc[each.value.vpc].vpc_id
  security_groups              = length(each.value.security_groups) > 0 ? [for sg_name in each.value.security_groups : module.tencent_singapore_sg[sg_name].security_group_id] : null
  load_balancer_pass_to_target = each.value.load_balancer_pass_to_target
  internet_bandwidth_max_out   = each.value.internet_bandwidth_max_out
  create_clb_log               = each.value.create_clb_log
  clb_log_set_period           = each.value.create_clb_log ? each.value.clb_log_set_period : null
  clb_log_topic_name           = each.value.create_clb_log ? each.value.clb_log_topic_name : null

  # 추가된 옵션들
  sla_type = try(each.value.sla_type, null)
  eip_address_id = try(each.value.eip_address, null) != null ? module.tencent_singapore_eip[each.value.eip_address].eip_id : null
  subnet_id = try(each.value.subnet, null) != null && each.value.network_type == "INTERNAL" ? module.tencent_singapore_vpc[each.value.vpc].subnets[each.value.subnet].id : null

}

