locals {
  tencent_cvm = {
    seoul = {
      test-vm = {
        type              = "SA2.MEDIUM2"
        availability_zone = "ap-seoul-2"
        vpc               = "vpc-c2v-test"
        subnet            = "c2v-test-platform"
        security_groups = [
          "default-rule"
        ]
        private_ip                  = "172.31.20.11"
        associate_public_ip_address = "true"
        internet_max_bandwidth_out  = "100" ## mbps

        image_name         = "rocky8-basic" #shared image
        system_disk_type = "CLOUD_PREMIUM"
        system_disk_size = "50"

        data_disks = {
          1 = {
            data_disk_size        = "50"
            data_disk_type        = "CLOUD_PREMIUM"
            data_disk_snapshot_id = null
          }
        }

        disable_api_termination = "true" ## protection 부분
      }
    }
  }
}

## official_module based custom_module
module "tencent_seoul_cvm" {
  source                      = "i-gitlab.c.com/common/tencent/cvm"
  for_each                    = local.tencent_cvm.seoul

  providers = {
    tencentcloud = tencentcloud.seoul
  }

  instance_name               = each.key
  availability_zone           = each.value.availability_zone
  instance_type               = each.value.type
  image_name                  = each.value.image_name
  vpc_id                      = module.tencent_seoul_vpc[each.value.vpc].vpc_id
  subnet_id                   = module.tencent_seoul_vpc[each.value.vpc].subnets[each.value.subnet].id
  security_group_ids          = length(each.value.security_groups) > 0 ? [for sg_name in each.value.security_groups : module.tencent_seoul_sg[sg_name].security_group_id] : null
  private_ip                  = each.value.private_ip
  associate_public_ip_address = each.value.associate_public_ip_address == "true" ? "true" : each.value.associate_public_ip_address == "false" ? "false" : module.tencent_seoul_eip[each.value.associate_public_ip_address].eip_id
  internet_max_bandwidth_out  = each.value.internet_max_bandwidth_out
  running_flag                = try(each.value.running_flag, "true")

  system_disk_type = each.value.system_disk_type
  system_disk_size = each.value.system_disk_size

  data_disks              = each.value.data_disks
  disable_api_termination = each.value.disable_api_termination


}