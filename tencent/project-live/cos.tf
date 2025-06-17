data "tencentcloud_user_info" "this" {} ## app id 체크용도

# singapore ---------------------------------------------------
module "mysqlbackup-asdasda" {
  source = "terraform-tencentcloud-modules/cos/tencentcloud"
  providers = {
    tencentcloud = tencentcloud.singapore
  }

  bucket_name = "mysqlbackup-adasd"
  appid       = data.tencentcloud_user_info.this.app_id
  bucket_acl  = "private"
  force_clean = true
  
  lifecycle_rules = [
    {
      transition = [{
        days          = "3"
        storage_class = "STANDARD_IA"
      }]
    },
    {
      expiration = [{
        days = 15
      }]
    }
  ]
}

