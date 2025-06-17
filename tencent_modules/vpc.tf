locals {
  tencent_vpc = {
    seoul = {
      vpc-c2v-test = {
        cidr_block = "172.31.0.0/16"
        subnets = [
          {
            subnet_name       = "c2v-test-platform"
            subnet_cidr       = "172.31.20.0/24"
            availability_zone = "ap-seoul-2"
          },
          {
            subnet_name       = "c2v-test-platform2"
            subnet_cidr       = "172.31.21.0/24"
            availability_zone = "ap-seoul-2"
          },
        ]
      }

      vpc-c2v-test2 = {
        cidr_block = "172.30.0.0/16"
        subnets = [
          {
            subnet_name       = "c2v-test2-platform"
            subnet_cidr       = "172.30.20.0/24"
            availability_zone = "ap-seoul-1"
          },
        ]
      }
    }
  }
}

## official_module based custom_module
module "tencent_seoul_vpc" {
  source   = "i-gitlab.co.com/common/tencent/vpc"
  for_each = local.tencent_vpc.seoul

  providers = {
    tencentcloud = tencentcloud.seoul
  }

  vpc_name = each.key
  vpc_cidr = each.value.cidr_block
  subnets  = each.value.subnets
}