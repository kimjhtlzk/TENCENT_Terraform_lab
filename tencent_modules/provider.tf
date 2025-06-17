terraform {
  required_version = "~> 1.9"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "1.81.137"
    }
  }
  backend "http" {}
}

################
### Tencent cloud info ###
###use terraform account
provider "tencentcloud" {
  secret_id  = "********************"
  secret_key = "********************"
  region     = "ap-seoul"
}

provider "tencentcloud" {
  secret_id  = "********************"
  secret_key = "********************"
  alias      = "seoul"
  region     = "ap-seoul"
}

provider "tencentcloud" {
  secret_id  = "********************"
  secret_key = "********************"
  alias      = "tokyo"
  region     = "ap-tokyo"
}