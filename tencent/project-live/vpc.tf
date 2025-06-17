locals {
  tencent_vpc = {
    singapore = {
      vpc-sfd-live-singapore = {
        cidr_block = "10.38.0.0/16"
        subnets = [
          {
            subnet_name       = "public-live-subnet-az3-1" # was
            subnet_cidr       = "10.38.10.0/24"
            availability_zone = "ap-singapore-3"
          },
          {
            subnet_name       = "public-live-subnet-az3-2" # mid
            subnet_cidr       = "10.38.11.0/24"
            availability_zone = "ap-singapore-3"
          },
          {
            subnet_name       = "public-live-subnet-az3-3" # db master
            subnet_cidr       = "10.38.12.0/24"
            availability_zone = "ap-singapore-3"
          },
          {
            subnet_name       = "public-live-subnet-az2-1" # db slave
            subnet_cidr       = "10.38.13.0/24"
            availability_zone = "ap-singapore-2"
          },
          {
            subnet_name       = "public-live-subnet-az1-1" # db rollback
            subnet_cidr       = "10.38.14.0/24"
            availability_zone = "ap-singapore-1"
          },

        ]
      }
    }

    frankfurt = {
      vpc-sfd-live-frankfurt = {
        cidr_block = "10.39.0.0/16"
        subnets = [
          {
            subnet_name       = "public-live-subnet-az1-1" # was
            subnet_cidr       = "10.39.10.0/24"
            availability_zone = "eu-frankfurt-1"
          },
          {
            subnet_name       = "public-live-subnet-az1-2" # mid
            subnet_cidr       = "10.39.11.0/24"
            availability_zone = "eu-frankfurt-1"
          },
          {
            subnet_name       = "public-live-subnet-az1-3" # db master
            subnet_cidr       = "10.39.12.0/24"
            availability_zone = "eu-frankfurt-1"
          },
          {
            subnet_name       = "public-live-subnet-az2-1" # db slave
            subnet_cidr       = "10.39.13.0/24"
            availability_zone = "eu-frankfurt-2"
          },
          {
            subnet_name       = "public-live-subnet-az2-2" # db rollback
            subnet_cidr       = "10.39.14.0/24"
            availability_zone = "eu-frankfurt-2"
          },

        ]
      }

    }
  }
}

## official_module based custom_module
module "tencent_singapore_vpc" {
  source   = "i-gitlab.co.com/common/tencent/vpc"
  for_each = local.tencent_vpc.singapore

  providers = {
    tencentcloud = tencentcloud.singapore
  }

  vpc_name = each.key
  vpc_cidr = each.value.cidr_block
  subnets  = each.value.subnets
}

module "tencent_frankfurt_vpc" {
  source   = "i-gitlab.co.com/common/tencent/vpc"
  for_each = local.tencent_vpc.frankfurt

  providers = {
    tencentcloud = tencentcloud.frankfurt
  }

  vpc_name = each.key
  vpc_cidr = each.value.cidr_block
  subnets  = each.value.subnets
}