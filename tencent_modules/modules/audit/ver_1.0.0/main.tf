data "tencentcloud_user_info" "info" {}

resource "tencentcloud_cos_bucket" "logging-bucket" {
  acceleration_enable = "false"
  acl                 = "private"

  bucket            = "logging-bucket-${data.tencentcloud_user_info.info.app_id}"
  log_enable        = "false"
  versioning_enable = "false"
}
 
resource "tencentcloud_audit_track" "track" {
  for_each = { for idx, track in var.audit_tracks : track.name => track }

  name                  = each.value.name
  resource_type         = lower(each.value.resource_type) # 소문자 필수
  event_names           = each.value.event_names
  action_type           = each.value.action_type
  status                = 1
  track_for_all_members = 0

  storage {
    storage_name   = replace(tencentcloud_cos_bucket.logging-bucket.bucket, "-${data.tencentcloud_user_info.info.app_id}", "")
    storage_prefix = each.value.storage.storage_prefix
    storage_region = "ap-seoul"
    storage_type   = each.value.storage.storage_type
  }
}