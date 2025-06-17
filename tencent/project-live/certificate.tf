locals {
  tencent_cm = {

      ## 도메인 + 마감기한 형식으로 리소스 생성
      "2025_u_cn" = {
        type = "SVR" ## 일반 인증서
        cert = "2025_u.cn_crt.pem" # puppet nginx file
        key  = "2025_u.cn_key.pem" # puppet nginx file
      }

  }
}

## custom_module
module "tencent_cm" {
  source = "i-gitlab.co.com/common/tencent/certificate"

  certificates = local.tencent_cm
}
