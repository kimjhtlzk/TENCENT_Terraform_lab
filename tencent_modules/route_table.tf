locals {
  tencent_rtb = {
    seoul = {
      rt-subnet-subnet = {
        vpc          = "vpc-c2v-test"
        asso_subnets = ["c2v-test-platform", "c2v-test-platform2"]
        rule = {
          1 = {
            cidr_block    = "0.0.0.0/0"
            resource_type = "EIP" ## 대문자 기입 필요
            next_hub      = "0"   ## EIP인 경우 반드시 0으로 작성
          }
          2 = {
            cidr_block    = "172.31.0.0/0"
            resource_type = "PEERCONNECTION"
            next_hub      = "pcx-8fye3evv" ## "peering"은 이곳에 id를 직접 입력합니다.
          }
        }
      }

      rt-subnet-subnet2 = {
        vpc          = "vpc-c2v-test"
        asso_subnets = ["c2v-test-platform2"]
        rule = {
          1 = {
            cidr_block    = "0.0.0.0/0"
            resource_type = "NAT"
            next_hub      = "ngw-eks-private"
          }
        }
      }
    }
  }
}

## custom module
module "tencent_seoul_rtb" {
  source   = "i-gitlab.c.com/common/tencent/routetable"
  for_each = local.tencent_rtb.seoul

  providers = {
    tencentcloud = tencentcloud.seoul
  }

  route_table_name = each.key
  vpc              = module.tencent_seoul_vpc[each.value.vpc].vpc_id
  asso_subnets     = [for sub in each.value.asso_subnets : module.tencent_seoul_vpc[each.value.vpc].subnets[sub].id]

  ## 현재는 NAT, Peering 정도만 예외 처리
  rule = [
    for rule in each.value.rule :
    {
      cidr_block    = rule.cidr_block
      resource_type = rule.resource_type
      next_hub      = rule.resource_type == "NAT" ? module.tencent_seoul_ngw[rule.next_hub].ngw_id : rule.resource_type == "PEERCONNECTION" ? rule.next_hub : 0

    }
  ]
  depends_on = [module.tencent_seoul_ngw, module.tencent_seoul_vpc]
}
