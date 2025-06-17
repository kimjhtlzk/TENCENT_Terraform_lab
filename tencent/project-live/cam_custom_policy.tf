locals {
  cam_policy = {
    I-Office = {
      policy = <<EOF
{
    "statement": [
        {
            "action": [
                "*"
            ],
            "condition": {
                "ip_not_equal": {
                    "qcs:ip": [
                        "110.30.12.0/24"
                    ]
                }
            },
            "effect": "deny",
            "resource": ["*"]
        }
    ],
    "version": "2.0"
}
        EOF
    }



    policy_CVM_OnOff = {
      policy = <<EOF
{
    "statement": [
        {
            "action": [
                "cvm:StartInstances",
                "cvm:RebootInstances",
                "cvm:StopInstances"
            ],
            "effect": "allow",
            "resource": ["*"]
        }
    ],
    "version": "2.0"
}
        EOF
    }



  }
}





## custom module
module "cam_policy" {
  source      = "i-gitlab.co.com/common/tencent/camcustompolicy"
  for_each    = local.cam_policy
  policy_name = each.key
  policy      = each.value.policy

}