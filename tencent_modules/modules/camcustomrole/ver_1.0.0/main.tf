resource "tencentcloud_cam_role" "role" {
  name              = var.role_name
  document          = var.document
  console_login     = var.console_login
  description       = var.description
  session_duration  = var.session_duration
}

resource "tencentcloud_cam_role_policy_attachment_by_name" "role_policy_attachment" {
  for_each    = toset(var.policy_name)
  role_name   = var.role_name
  policy_name = each.key  
} 