resource "tencentcloud_cam_group" "group" {
  name     = var.group_name
}
 
resource "tencentcloud_cam_group_membership" "addmember" {
  group_id   = tencentcloud_cam_group.group.id
  user_names = var.user_name
  depends_on = [ tencentcloud_cam_group.group ]
}

data "tencentcloud_cam_policies" "policy" {
  for_each = { for policy_name in var.policy : policy_name => policy_name }
  name = each.key
}

resource "tencentcloud_cam_group_policy_attachment" "group_policy_attachment_basic" {
  for_each = data.tencentcloud_cam_policies.policy
  group_id = tencentcloud_cam_group.group.id
  policy_id = each.value.policy_list.0.policy_id
}