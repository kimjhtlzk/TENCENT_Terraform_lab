terraform {
  required_version = "~> 1.9"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "= 1.81.163"
    }
  }
  backend "http" {}
}

################
### Tencent cloud info ###
###use terraform account
provider "tencentcloud" {
  secret_id  = "**************************"
  secret_key = "**************************"
  region     = "ap-seoul"
}

provider "tencentcloud" {
  secret_id  = "**************************"
  secret_key = "**************************"
  alias      = "seoul"
  region     = "ap-seoul"
}

provider "tencentcloud" {
  secret_id  = "**************************"
  secret_key = "**************************"
  alias      = "tokyo"
  region     = "ap-tokyo"
}

provider "tencentcloud" {
  secret_id  = "**************************"
  secret_key = "**************************"
  alias      = "singapore"
  region     = "ap-singapore"
}
provider "tencentcloud" {
  secret_id  = "**************************"
  secret_key = "**************************"
  alias      = "frankfurt"
  region     = "eu-frankfurt"
}
