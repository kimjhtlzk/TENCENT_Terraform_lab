## 공식모듈, deprecated된 리소스 tencentcloud_security_group_rule 제외
locals {
  create     = var.create && var.create_sg
  this_sg_id = var.security_group_id != "" ? var.security_group_id : concat(tencentcloud_security_group.sg.*.id, [""])[0]
}

# ------------------------
# Security group with name
# ------------------------
resource "tencentcloud_security_group" "sg" {
  count       = local.create ? 1 : 0
  name        = var.name
  description = var.description
  project_id  = var.project_id
  tags        = merge(var.tags, var.security_group_tags)
}

# -------------------------
# Security group lite rules
# -------------------------
# NOTE:It can't be used with tencentcloud_security_group_rule, and don't create multiple 
# tencentcloud_security_group_rule resources, otherwise it may cause problems.
resource "tencentcloud_security_group_lite_rule" "lite_rule" {
  count             = var.create_lite_rule ? 1 : 0
  security_group_id = local.this_sg_id
  ingress           = var.ingress_for_lite_rule
  egress            = var.egress_for_lite_rule
}

# --------------------------------------------------------------------------
# Ingress - List of rules (simple)
# --------------------------------------------------------------------------
locals {
  ingress_rules = flatten(
    [
      for _, rl in var.ingress_rules : [
        for _, cidr in var.ingress_cidr_blocks : {
          cidr_block = cidr
          rule       = rl
          policy     = var.ingress_policy
        }
      ]
    ]
  )
}

# ------------------------------------------------------------------------------------------------
# Ingress - Map of rules
# Security group ingress rules with "cidr_blocks", but without "source_sgid" and "address_template"
# ------------------------------------------------------------------------------------------------
locals {
  ingress_with_cidr_blocks = flatten(
    [
      for _, obj in var.ingress_with_cidr_blocks : [
        for _, cidr in split(",", lookup(obj, "cidr_block", join(",", var.ingress_cidr_blocks))) : {
          cidr_block  = cidr
          policy      = lookup(obj, "policy", var.ingress_policy)
          port        = lookup(obj, "port", lookup(obj, "rule", null) == null ? null : var.rules[lookup(obj, "rule", "_")][0] - lookup(obj, "rule", null) == null ? 0 : var.rules[lookup(obj, "rule", "_")][1])
          protocol    = lookup(obj, "protocol", var.rules[lookup(obj, "rule", "_")][2])
          description = lookup(obj, "description", lookup(obj, "rule", null) == null ? format("Ingress Rule With Cidr Block %s", cidr) : var.rules[lookup(obj, "rule", "_")][3])
        }
      ]
    ]
  )
}

# -------------------------------------------------------------------------------------------------
# Security group ingress rules with "source_sgid", but without "cidr_blocks" and "address_template"
# -------------------------------------------------------------------------------------------------
locals {
  ingress_with_source_sgids = flatten(
    [
      for _, obj in var.ingress_with_source_sgids : {
        source_sgid = lookup(obj, "source_sgid", "")
        policy      = lookup(obj, "policy", var.ingress_policy)
        port        = lookup(obj, "port", lookup(obj, "rule", null) == null ? null : var.rules[lookup(obj, "rule", "_")][0] - lookup(obj, "rule", null) == null ? 0 : var.rules[lookup(obj, "rule", "_")][1])
        protocol    = lookup(obj, "protocol", var.rules[lookup(obj, "rule", "_")][2])
        description = lookup(obj, "description", lookup(obj, "rule", null) == null ? format("Ingress Rule With Source Security Group %s", lookup(obj, "source_sgid", "")) : var.rules[lookup(obj, "rule", "_")][3])
      }
    ]
  )
} 

# -------------------------------------------------------------------------------------------------
# Security group ingress rules with "address_template", but without "cidr_blocks" and "source_sgid"
# -------------------------------------------------------------------------------------------------
locals {
  ingress_with_address_templates = flatten(
    [
      for _, obj in var.ingress_with_address_templates : {
        address_template = lookup(obj, "address_template", [])
        policy           = lookup(obj, "policy", var.ingress_policy)
        port             = lookup(obj, "port", lookup(obj, "rule", null) == null ? null : var.rules[lookup(obj, "rule", "_")][0] - lookup(obj, "rule", null) == null ? 0 : var.rules[lookup(obj, "rule", "_")][1])
        protocol         = lookup(obj, "protocol", var.rules[lookup(obj, "rule", "_")][2])
        description      = lookup(obj, "description", lookup(obj, "rule", null) == null ? "Ingress Rule With Address Template" : var.rules[lookup(obj, "rule", "_")][3])
      }
    ]
  )
}

# --------------------------------------------------------------------------
# Egress - List of rules (simple)
# --------------------------------------------------------------------------
locals {
  egress_rules = flatten(
    [
      for _, rl in var.egress_rules : [
        for _, cidr in var.egress_cidr_blocks : {
          cidr_block = cidr
          rule       = rl
          policy     = var.egress_policy
        }
      ]
    ]
  )
}

# ------------------------------------------------------------------------------------------------
# Security group egress rules with "cidr_blocks", but without "source_sgid" and "address_template"
# ------------------------------------------------------------------------------------------------
locals {
  egress_with_cidr_blocks = flatten(
    [
      for _, obj in var.egress_with_cidr_blocks : [
        for _, cidr in split(",", lookup(obj, "cidr_block", join(",", var.egress_cidr_blocks))) : {
          cidr_block  = cidr
          policy      = lookup(obj, "policy", var.egress_policy)
          port        = lookup(obj, "port", lookup(obj, "rule", null) == null ? null : var.rules[lookup(obj, "rule", "_")][0] - lookup(obj, "rule", null) == null ? 0 : var.rules[lookup(obj, "rule", "_")][1])
          protocol    = lookup(obj, "protocol", var.rules[lookup(obj, "rule", "_")][2])
          description = lookup(obj, "description", lookup(obj, "rule", null) == null ? format("Egress Rule With Cidr Block %s", cidr) : var.rules[lookup(obj, "rule", "_")][3])
        }
      ]
    ]
  )
}

# ------------------------------------------------------------------------------------------------
# Security group egress rules with "source_sgid", but without "cidr_blocks" and "address_template"
# ------------------------------------------------------------------------------------------------
locals {
  egress_with_source_sgids = flatten(
    [
      for _, obj in var.egress_with_source_sgids : {
        source_sgid = lookup(obj, "source_sgid", "")
        policy      = lookup(obj, "policy", var.egress_policy)
        port        = lookup(obj, "port", lookup(obj, "rule", null) == null ? null : var.rules[lookup(obj, "rule", "_")][0] - lookup(obj, "rule", null) == null ? 0 : var.rules[lookup(obj, "rule", "_")][1])
        protocol    = lookup(obj, "protocol", var.rules[lookup(obj, "rule", "_")][2])
        description = lookup(obj, "description", lookup(obj, "rule", null) == null ? format("Egress Rule With Source Security Group %s", lookup(obj, "source_sgid", "")) : var.rules[lookup(obj, "rule", "_")][3])
      }
    ]
  )
}

# -------------------------------------------------------------------------------------------------
# Security group egress rules with "address_template", but without "cidr_blocks" and "source_sgid"
# -------------------------------------------------------------------------------------------------
locals {
  egress_with_address_templates = flatten(
    [
      for _, obj in var.egress_with_address_templates : {
        address_template = lookup(obj, "address_template", [])
        policy           = lookup(obj, "policy", var.ingress_policy)
        port             = lookup(obj, "port", lookup(obj, "rule", null) == null ? null : var.rules[lookup(obj, "rule", "_")][0] - lookup(obj, "rule", null) == null ? 0 : var.rules[lookup(obj, "rule", "_")][1])
        protocol         = lookup(obj, "protocol", var.rules[lookup(obj, "rule", "_")][2])
        description      = lookup(obj, "description", lookup(obj, "rule", null) == null ? "Ingress Rule With Address Template" : var.rules[lookup(obj, "rule", "_")][3])
      }
    ]
  )
}