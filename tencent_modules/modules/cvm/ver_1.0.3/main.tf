data "tencentcloud_images" "image" {
  image_name_regex   = var.image_name
  image_type         = ["SHARED_IMAGE", "PRIVATE_IMAGE", "PUBLIC_IMAGE"]
}
 
## tencent는 instance 생성 리소스에 eni 구성이 포함되어 있음 분리 불가...
resource "tencentcloud_instance" "instance" {

  instance_name     = var.instance_name
  availability_zone = var.availability_zone
  image_id          = data.tencentcloud_images.image.images[0].image_id
  instance_type     = var.instance_type

  system_disk_type = var.system_disk_type
  system_disk_size = var.system_disk_size

  project_id                 = var.project_id
  vpc_id                     = var.vpc_id
  subnet_id                  = var.subnet_id
  private_ip                 = var.private_ip

  orderly_security_groups = var.security_group_ids
  disable_monitor_service = !var.monitoring
  cam_role_name           = var.cam_role_name

  instance_charge_type = var.instance_charge_type
  disable_api_termination = var.disable_api_termination

  #tags = {
  #  Name = var.instance_name
  #}

  running_flag            = var.running_flag

  # platform_details값을 통한 OS 구분
  # OS 별 userdata 값 적용
  # tencentcloud_images 값이 null 일경우 tempos로 할당, Windows는 windows_user_data, 나머지 platform은 linux_user_data 값 입력
  # user_data 지원하는 윈도우 운영체제
  # https://www.tencentcloud.com/ko/document/product/213/17526  
  user_data = base64encode(
    startswith(
      length(data.tencentcloud_images.image.images) > 0 ?
      data.tencentcloud_images.image.images[0].platform : "tempos",
      "Windows"
    ) ?
    <<-WINDOWS
      <powershell>
          Rename-Computer -NewName ${var.instance_name} -Force
          Restart-Computer -Force
      </powershell>
    WINDOWS
    :
    <<-LINUX
      #!/bin/bash
      hostnamectl set-hostname ${var.instance_name}.co.kr
      rm -rf /etc/passwd.lock /etc/shadow.lock
    LINUX
  )

  # ForceNew 이슈
  lifecycle {
      ignore_changes = [ user_data, image_id, hostname, cam_role_name ]
  }
}


# -----------------------------------------------------------------------

resource "tencentcloud_eip" "eip" {
  count = var.associate_public_ip_address == "true" ? 1 : 0
  name                 = "eip-${var.instance_name}"
  internet_charge_type = "TRAFFIC_POSTPAID_BY_HOUR"
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  type                 = "EIP"

}

resource "tencentcloud_eip_association" "eip_att" {
  count = var.associate_public_ip_address == "true" ? 1 : 0
  instance_id = tencentcloud_instance.instance.id
  eip_id = tencentcloud_eip.eip[count.index].id

  depends_on = [tencentcloud_instance.instance]
}

resource "tencentcloud_eip_association" "eip_att_exist" {
  count = var.associate_public_ip_address != "true" && var.associate_public_ip_address != "false" ? 1 : 0
  instance_id = tencentcloud_instance.instance.id
  eip_id = var.associate_public_ip_address

  depends_on = [tencentcloud_instance.instance]
}

# -----------------------------------------------------------------------


resource "tencentcloud_cbs_storage" "cbs" {
  for_each = var.data_disks
  availability_zone = var.availability_zone
  storage_name      = "${var.instance_name}-${each.key}"
  storage_size      = each.value.data_disk_size
  storage_type      = each.value.data_disk_type
  snapshot_id      = each.value.data_disk_snapshot_id

  # tags = {
  #       Name = "${var.instance_name}-${each.key}"
  # }

}

resource "tencentcloud_cbs_storage_attachment" "attachment" {
  for_each    = var.data_disks
  storage_id  = tencentcloud_cbs_storage.cbs[each.key].id
  instance_id = tencentcloud_instance.instance.id

  depends_on = [tencentcloud_instance.instance]
}