locals {
  accounts = {
    # service account
    monitor = {
      console_login   = "false"
      password_reset  = "false"
      service_account = "true"
      email           = ""
      policy = [ # 그룹권한이 아닌 특정유저에게 특정 권한을 추가하기 위함
        "QcloudCVMReadOnlyAccess",
        "QcloudFinanceBillReadOnlyAccess"
      ]
    },

  }
}

## custom_module
module "cam_user" {
  source         = "i-gitlab.c.com/common/tencent/camuser"
  for_each       = local.accounts
  iam_name       = each.key
  console_login  = each.value.console_login
  password_reset = each.value.password_reset
  sa             = each.value.service_account
  email          = each.value.email
  policy = [
    for policy in each.value.policy : policy
  ]
}