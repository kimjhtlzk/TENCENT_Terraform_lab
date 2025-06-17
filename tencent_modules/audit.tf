locals {
  audit_tracks = [
    {
      name                  = "disk_trackingset"
      resource_type         = "CBS"
      event_names           = [
        "ResizeDisk",
        ]
      action_type           = "*"
      storage = {
        storage_prefix = "disk"
        storage_type   = "cos"
      }
    },
    {
      name                  = "iam_trackingset"
      resource_type         = "CAM"
      event_names           = [
        "AddUser",
        "DeleteUser",
        "CreateApiKey",
        "DeleteApiKey",
        "DetachUserPolicies",
        "DetachUserPolicy",
        "AttachUserPolicy",
        ]
      action_type           = "*"
      storage = {
        storage_prefix = "cam"
        storage_type   = "cos"
      }
    },
    {
      name                  = "vm_trackingset"
      resource_type         = "CVM"
      event_names           = [
        "RunInstances",
        "TerminateInstances",
        "ResetInstancesType",
        "DetachDisks",
        "AttachDisks",
        "StopInstances",
        "StartInstances",
        ]
      action_type           = "*"
      storage = {
        storage_prefix = "cvm"
        storage_type   = "cos"
      }
    },
    {
      name                  = "vpc_trackingset"
      resource_type         = "VPC"
      event_names           = [
        "CreateSecurityGroupPolicies",
        "DeleteSecurityGroupPolicies",
        "DisassociateAddress",
        "ModifySecurityGroupPolicies",
        "ReplaceSecurityGroupPolicies",
        ]
      action_type           = "*"
      storage = {
        storage_prefix = "vpc"
        storage_type   = "cos"
      }
    }
    # 추가적인 audit_track 설정을 여기에 더 추가할 수 있습니다.
  ]
}

module "audit" {
  source      = "i-gitlab.co.com/common/tencent/audit"
  audit_tracks = local.audit_tracks

}