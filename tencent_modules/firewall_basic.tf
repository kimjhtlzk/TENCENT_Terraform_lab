module "tencent_seoul_sg" {
  source = "i-gitlab.co.com/common/tencent/c2sfirewall"
  providers = {
    tencentcloud = tencentcloud.seoul
  }
}