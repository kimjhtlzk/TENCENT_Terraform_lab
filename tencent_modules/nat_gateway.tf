locals {
  tencent_ngw = {
    seoul = { # 생성할 eip의 이름만 작성
      ngw-ity0104-test = {
        eip         = "true" # "true" or eip name
        vpc         = "vpc-c2v-test"
      }
      ngw-ity0104-test2 = {
        eip         = "test22-external"
        vpc         = "vpc-c2v-test"
      }
    }
  }
}

## custom_module
module "tencent_seoul_ngw" {
  source   = "i-gitlab.c.com/common/tencent/nat"
  for_each = local.tencent_ngw.seoul

  providers = {
    tencentcloud = tencentcloud.seoul
  }

  ngw_name = each.key
  eip      = each.value.eip
  vpc      = module.tencent_seoul_vpc[each.value.vpc].vpc_id

  depends_on = [module.tencent_seoul_vpc]
}
  