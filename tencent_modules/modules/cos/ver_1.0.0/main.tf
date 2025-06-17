# https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-cos

data "tencentcloud_user_info" "info" {}

resource "tencentcloud_cos_bucket" "cos" {
  bucket              = "${var.cos_name}-${data.tencentcloud_user_info.info.app_id}"
  acceleration_enable = var.acceleration_enable
  acl                 = var.acl                
  log_enable          = var.log_enable         
  versioning_enable   = var.versioning_enable
  force_clean         = var.force_clean

  dynamic "lifecycle_rules" {
    for_each = var.lifecycle_rules
    content {
      filter_prefix = lookup(lifecycle_rules.value, "filter_prefix", "")

      dynamic "expiration" {
        for_each = lookup(lifecycle_rules.value, "expiration", [])
        content {
          date = lookup(expiration.value, "date", null)
          days = lookup(expiration.value, "days", null)
        }
      }

      dynamic "transition" {
        for_each = lookup(lifecycle_rules.value, "transition", [])
        content {
          storage_class = lookup(transition.value, "storage_class", null)
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
        }
      }
    }
  }  
}

