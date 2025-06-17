locals {
  tencent_cvm = { # "TencentOS Server 3.1 \\(TK4\\) UEFI版"
    singapore = {
      # was
      asdasd-live-start-t01 = {
        type              = "S5.LARGE8"
        availability_zone = "ap-singapore-3"
        vpc               = "vpc-asdas-live-singapore"
        subnet            = "public-live-subnet-az3-1"
        security_groups = [
          "live-start-sg", "live-wassubnet-common-sg", "basic-singapore-live-sg"
        ]
        private_ip                  = "10.38.10.61"
        associate_public_ip_address = "asdasd-live-start-t01"
        internet_max_bandwidth_out  = "100" ## mbps
        running_flag = true

        image_name       = "TencentOS Server 3.1 \\(TK4\\) UEFI版" #shared image
        system_disk_type = "CLOUD_PREMIUM"
        system_disk_size = "50"

        data_disks = {
          1 = {
            data_disk_size        = "50"
            data_disk_type        = "CLOUD_PREMIUM"
            data_disk_snapshot_id = null
          }
          2 = {
            data_disk_size        = "10"
            data_disk_type        = "CLOUD_PREMIUM"
            data_disk_snapshot_id = null
          }
        }

        disable_api_termination = "true" ## protection 부분
      }

    }

  }
}



module "tencent_singapore_cvm" {
  source    = "i-gitlab.co.com/common/tencent/cvm"
  version   = "1.0.3"
  for_each  = local.tencent_cvm.singapore

  providers = {
    tencentcloud = tencentcloud.singapore
  }

  instance_name               = each.key
  availability_zone           = each.value.availability_zone
  instance_type               = each.value.type
  image_name                  = each.value.image_name
  vpc_id                      = module.tencent_singapore_vpc[each.value.vpc].vpc_id
  subnet_id                   = module.tencent_singapore_vpc[each.value.vpc].subnets[each.value.subnet].id
  security_group_ids          = length(each.value.security_groups) > 0 ? [for sg_name in each.value.security_groups : module.tencent_singapore_sg[sg_name].security_group_id] : null
  private_ip                  = each.value.private_ip
  associate_public_ip_address = each.value.associate_public_ip_address == "true" ? "true" : each.value.associate_public_ip_address == "false" ? "false" : module.tencent_singapore_eip[each.value.associate_public_ip_address].eip_id
  internet_max_bandwidth_out  = each.value.internet_max_bandwidth_out
  running_flag                = try(each.value.running_flag, "true")
  cam_role_name               = try(each.value.cam_role_name, tencentcloud_cam_role.cvm_role.name)
  system_disk_type            = each.value.system_disk_type
  system_disk_size            = each.value.system_disk_size

  data_disks                  = each.value.data_disks
  disable_api_termination     = each.value.disable_api_termination
}

