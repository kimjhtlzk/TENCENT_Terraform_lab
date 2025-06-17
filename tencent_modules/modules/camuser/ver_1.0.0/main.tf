data "tencentcloud_cam_policies" "policy" {
  for_each = { for policy_name in var.policy : policy_name => policy_name }
  name = each.key
}
 
resource "tencentcloud_cam_user" "account" {
  #use_api             = false
  name                = var.iam_name
  console_login       = var.console_login
  need_reset_password = var.password_reset
  password            = "Co!@#"
  email               = var.email
  use_api             = "false"
  force_delete        = false ## api 키가 존재 할 때 강제 삭제 여부
  lifecycle {
    ignore_changes = [
      phone_num,
      email,
      password
    ]
  }
}

resource "tencentcloud_cam_user_policy_attachment" "user_policy_attachment_basic" {
  for_each = data.tencentcloud_cam_policies.policy
  user_name = tencentcloud_cam_user.account.id
  policy_id = each.value.policy_list.0.policy_id
}

## 계정에 대한 MFA setting, 서비스계정일 경우 비활성화
resource "tencentcloud_cam_mfa_flag" "mfa_flag" {
  count = var.sa ? 0 : 1
  op_uin = tencentcloud_cam_user.account.uin
  login_flag { ## login 인증 / 사용
    phone  = 0
    stoken = 1
    wechat = 0
  }
  action_flag { ## operation 인증 / 사용안함
    phone  = 0
    stoken = 0
    wechat = 0
  }
}