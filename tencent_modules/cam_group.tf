locals {
  groups = {
    # Infra-C-SE = {
    #   policy = [
    #     "cvm-OnOff"
    #   ]
    #   users = [

    # },

  }
}

## custom module
module "cam_group" {
  source     = "i-gitlab.co.com/common/tencent/camgroup"
  for_each   = local.groups
  group_name = each.key
  policy = [
    for policy in each.value.policy : policy
  ]
  user_name = each.value.users
} 