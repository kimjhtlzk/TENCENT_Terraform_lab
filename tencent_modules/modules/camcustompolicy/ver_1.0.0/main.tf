resource "tencentcloud_cam_policy" "policy" {
  name        = var.policy_name
  document    = var.policy
} 