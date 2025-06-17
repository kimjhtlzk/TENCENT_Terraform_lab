locals {
  groups = {
    # Ia-C-Team = {
    #   policy = [
    #     "Infra-Office",
    #     "QcloudCollMFAManageAccess",
    #     "QcloudCollPasswordManageAccess",
    #     "ReadOnlyAccess"
    #   ]
    #   users = [
    #     "user1@co.com",
    #   ]
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