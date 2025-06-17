locals {
  tencent_eip = {
    singapore = {
     # was
     asdasd-live-start-t01 = { eip_internet_max_bandwidth_out = "100" }

  }
}


module "tencent_singapore_eip" {
  source                         = "i-gitlab.co.com/common/tencent/eip"
  for_each                       = local.tencent_eip.singapore

  providers = {
    tencentcloud = tencentcloud.singapore
  }

  eip_name                       = each.key
  eip_internet_max_bandwidth_out = each.value.eip_internet_max_bandwidth_out
}

