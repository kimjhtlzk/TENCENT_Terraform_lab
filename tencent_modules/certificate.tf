locals {
  tencent_cm = {
       ##이전 인증서는 교체 전까지 삭제 금지
       "2025_u_cn" = {
         type = "SVR"
         cert = "2025_u.cn_crt.pem"
         key  = "2025_u.cn_key.pem"
       }
  }
}

module "tencent_cm" {
  source = "i-gitlab.c.com/common/tencent/certificate"

  certificates = local.tencent_cm
}