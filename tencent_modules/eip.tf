locals {
  tencent_eip = {
    seoul = {
        test22-external = { eip_internet_max_bandwidth_out = "100" }

    } 
  }
}

## official_module based custom_module
module "tencent_seoul_eip" {
  source   = "i-gitlab.co.com/common/tencent/eip"
  for_each                       = local.tencent_eip.seoul

  providers = {
    tencentcloud = tencentcloud.seoul
  }

  eip_name                       = each.key
  eip_internet_max_bandwidth_out = each.value.eip_internet_max_bandwidth_out
}