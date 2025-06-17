locals {
  tencent_cos = {
    seoul = {
      # Live
      sdxx365-live-1122 = {
        acceleration_enable = "false"
        acl                 = "private"
        log_enable          = "false"
        versioning_enable   = "false"
        
        # lifecycle_rules 설정 추가
        lifecycle_rules = [
          {
            filter_prefix = ""  # 기본적으로 전체 버킷
            expiration = [
              {
                days = 15
              }
            ]
            transition = [
              {
                days          = 3
                storage_class = "STANDARD_IA"
              }
            ]
          }
        ]
      }
    }
  }
}
module "tencent_seoul_cos" {
  source                  = "i-gitlab.c.com/common/tencent/cos"
  for_each                = local.tencent_cos.seoul

  providers = {
    tencentcloud = tencentcloud.seoul
  }

  cos_name                = each.key
  acceleration_enable     = each.value.acceleration_enable
  acl                     = each.value.acl
  log_enable              = each.value.log_enable
  versioning_enable       = each.value.versioning_enable
  force_clean             = try(each.value.force_clean, true)
  lifecycle_rules         = length(each.value.lifecycle_rules) > 0 ? each.value.lifecycle_rules : []
}
