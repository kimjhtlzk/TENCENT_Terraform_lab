locals {
  cam_custom_role = {
    "@owner" = {
      document = jsonencode(
        {
          statement = [
            {
              action = "name/sts:AssumeRole"
              effect = "allow"
              principal = {
                qcs = [
                  "qcs::cam::uin/4545645645:root",
                ]
              }
            },
          ]
          version = "2.0"
        }
      )
      console_login = true ## Use switching role
      description   = "owner_role"
      session_duration = 7200
      policy_name = [
        "AdministratorAccess"
      ]
    }

    "@admin" = {
      document = jsonencode(
        {
          statement = [
            {
              action = "name/sts:AssumeRole"
              effect = "allow"
              principal = {
                qcs = [
                  "qcs::cam::uin/456456456:root",
                ]
              }
            },
          ]
          version = "2.0"
        }
      )
      console_login = true ## Use switching role
      description   = "admin_role"
      session_duration = 7200
      policy_name = [
        "QcloudCamFullAccess",
        "QcloudVPCFullAccess",
        "QcloudCVMFullAccess",
        "QcloudCLSFullAccess",
        "QcloudCOSFullAccess",
        "QcloudSSLFullAccess",
        "ReadOnlyAccess"
      ]
    }

    "@SE" = {
      document = jsonencode(
        {
          statement = [
            {
              action = "name/sts:AssumeRole"
              effect = "allow"
              principal = {
                qcs = [
                  "qcs::cam::uin/456456456456:root",
                ]
              }
            },
          ]
          version = "2.0"
        }
      )
      console_login = true ## Use switching role
      description   = "SE_role"
      session_duration = 7200
      policy_name = [
        "QcloudCamFullAccess",
        "ReadOnlyAccess",
        "policy_CVM_OnOff",
        "QcloudCSMFullAccess"
      ]
    }

    "@DBA" = {
      document = jsonencode(
        {
          statement = [
            {
              action = "name/sts:AssumeRole"
              effect = "allow"
              principal = {
                qcs = [
                  "qcs::cam::uin/45645645645:root",
                ]
              }
            },
          ]
          version = "2.0"
        }
      )
      console_login = true ## Use switching role
      description   = "DBA_role"
      session_duration = 7200
      policy_name = [
        "ReadOnlyAccess"
      ]
    }
  }
}

## custom module
module "cam_custom_role" {
  source           = "i-gitlab.c.com/common/tencent/camcustomrole"
  for_each         = local.cam_custom_role
  role_name        = each.key
  document         = each.value.document
  console_login    = lookup(each.value, "console_login", null)
  description      = lookup(each.value, "description", null)
  session_duration = lookup(each.value, "session_duration", 7200)
  policy_name = [
    for policy_name in lookup(each.value, "policy_name", []) : policy_name
  ]

  depends_on = [module.cam_policy]
}