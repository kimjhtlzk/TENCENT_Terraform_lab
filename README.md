# Tencent Cloud Terraform Lab

> Real-world Tencent Cloud infrastructure code, designed for direct use in production environments.  
> Primarily integrated with **GitLab CI/CD**, with some exceptions.

---

## Overview

This repository contains Terraform code for provisioning and managing Tencent Cloud infrastructure.  
All configurations are written at a production-ready level and can be applied directly to real-world projects.

> **Note from experience:**  
> Tencent Cloud Terraform support is still maturing compared to AWS or Azure.  
> Modules are not updated on a regular release cycle, so it's essential to always verify  
> whether new or updated modules have been released before implementation.  
> Managing Tencent Cloud with Terraform requires extra attention to provider versioning  
> and module availability — but it's absolutely doable with the right structure.

---

## Repository Structure

```
TENCENT_Terraform_lab/
│
├── modules/
│   ├── vpc/                  # VPC, Subnet, Route Table
│   ├── cvm/                  # Cloud Virtual Machine
│   ├── cam/                  # Cloud Access Management
│   └── security_group/       # Security Group rules
│
├── environments/
│   ├── dev/
│   ├── stg/
│   └── prod/
│
├── .gitlab-ci.yml
└── README.md
```

---

## Prerequisites

| Tool | Version |
|------|---------|
| Terraform | >= 1.0.0 |
| Tencent Cloud CLI (`tccli`) | >= 3.0 |
| GitLab Runner | (for CI/CD) |

---

## Getting Started

```bash
# 1. Clone the repository
git clone https://github.com/kimjhtlzk/TENCENT_Terraform_lab.git

# 2. Configure Tencent Cloud credentials
export TENCENTCLOUD_SECRET_ID="your_secret_id"
export TENCENTCLOUD_SECRET_KEY="your_secret_key"
export TENCENTCLOUD_REGION="ap-seoul"

# 3. Initialize Terraform
terraform init

# 4. Plan
terraform plan

# 5. Apply
terraform apply
```

---

## ⚠️ Important: Module Version Check

Tencent Cloud Terraform provider modules are **not updated on a regular basis**.  
Always verify the latest provider version before starting a new project:

```bash
# Check latest provider version
terraform providers

# Or visit:
# https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest
```

---

## CI/CD Integration

This repository is primarily designed to work with **GitLab CI/CD**.  
All module code is managed centrally in GitLab for collaboration.

Pipeline stages:
- `validate` — Terraform format & validation check
- `plan` — Generate and review execution plan
- `apply` — Apply changes to target environment

---

## Tech Stack

| Category | Tool |
|----------|------|
| IaC | Terraform |
| Cloud | Tencent Cloud |
| CI/CD | GitLab |
| Language | HCL, Shell |

---

## Author

**JunHyun Kim** — Cloud Infrastructure Engineer  
[![GitHub](https://img.shields.io/badge/GitHub-kimjhtlzk-181717?logo=github)](https://github.com/kimjhtlzk)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-ihanni-0077B5?logo=linkedin)](http://www.linkedin.com/in/ihanni)
