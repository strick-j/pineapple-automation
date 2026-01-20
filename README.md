# Pineapple Automation - Terraform Infrastructure

A comprehensive Terraform-based infrastructure deployment on AWS, integrated with CyberArk's identity and secret management platform. This project automates the provisioning of a complete development environment with networking, compute, database, and storage components.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Directory Structure](#directory-structure)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Module Documentation](#module-documentation)
- [Configuration](#configuration)
- [Security](#security)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)

## Overview

This Terraform project deploys a secure, multi-tier AWS infrastructure with the following capabilities:

- **Networking**: VPC with public/private subnets, NAT Gateway, and VPC endpoints
- **Compute**: EC2 instances configured as CyberArk SIA connectors and targets
- **Database**: AWS RDS MySQL instance
- **Storage**: S3 bucket with automated script synchronization
- **Security**: IAM roles, security groups, and SSH key pair management
- **Secret Management**: Full CyberArk Conjur integration for credential management

### Key Features

- Modular, reusable infrastructure components
- CyberArk SIA (Secure Infrastructure Access) integration
- Dynamic credential injection via Conjur
- Remote state management with S3 and DynamoDB locking
- Comprehensive tagging strategy for compliance
- Security best practices with private subnets and restrictive security groups

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS VPC                             │
│                     (192.168.0.0/16)                        │
│                                                             │
│  ┌────────────────────────┐  ┌──────────────────────────┐  │
│  │  Public Subnet         │  │  Private Subnet          │  │
│  │  (192.168.200.0/24)    │  │  (192.168.201.0/24)      │  │
│  │                        │  │                          │  │
│  │  ┌──────────────┐      │  │  ┌────────────────┐     │  │
│  │  │ NAT Gateway  │      │  │  │ Linux Connector│     │  │
│  │  │              │      │  │  │ (SIA)          │     │  │
│  │  └──────────────┘      │  │  └────────────────┘     │  │
│  │                        │  │                          │  │
│  │                        │  │  ┌────────────────┐     │  │
│  └────────────────────────┘  │  │ Linux Target   │     │  │
│              │               │  │                │     │  │
│       Internet Gateway       │  └────────────────┘     │  │
│                              │                          │  │
│                              │  ┌────────────────┐     │  │
│                              │  │ RDS MySQL      │     │  │
│                              │  │ (music DB)     │     │  │
│                              │  └────────────────┘     │  │
│                              └──────────────────────────┘  │
│                                                             │
│  S3 VPC Gateway Endpoint ────────────────────────────────┐ │
└──────────────────────────────────────────────────────────┼─┘
                                                           │
                                       ┌───────────────────▼──┐
                                       │  S3 Bucket           │
                                       │  (Scripts Storage)   │
                                       └──────────────────────┘
```

## Directory Structure

```
terraform/
├── main.tf                          # Root module orchestration
├── variables.tf                     # Root-level variables
├── default.tfvars                   # Default variable values
├── provider.tf                      # AWS & Conjur provider configuration
├── backend.tf                       # S3-based state management
└── modules/
    ├── infra/
    │   ├── network/
    │   │   ├── vpc/                 # VPC, subnets, IGW, NAT, routes
    │   │   ├── security_groups/     # Security group definitions
    │   │   └── subnets/
    │   │       └── database/rds/mysql_subnet_group/
    │   ├── compute/
    │   │   └── ec2/
    │   │       ├── connectors/
    │   │       │   └── linux_connector/  # CyberArk SIA connector
    │   │       └── targets/
    │   │           └── linux_target/     # Managed target system
    │   ├── database/
    │   │   └── rds/mysql/           # MySQL RDS instance
    │   └── storage/
    │       └── s3/                  # S3 bucket with scripts sync
    └── security/
        ├── key_pair/                # SSH key pair generation
        └── roles/
            └── ec2/s3_ro_role/      # S3 read-only IAM role
```

## Prerequisites

### Required Software

- [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- Access to a CyberArk Identity tenant
- Access to a CyberArk Conjur instance

### Required Accounts & Access

- AWS Account with AdministratorAccess permissions
- CyberArk Identity tenant credentials
- CyberArk Conjur account and API key
- SSH public key for EC2 instance access

### AWS Resources (Pre-existing)

The following AWS resources must exist before deployment:

- S3 bucket: `pineapple.dev` (for Terraform state)
- DynamoDB table: `pineapple-terraform-lock-table` (for state locking)

## Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd pineapple-automation/terraform
```

### 2. Configure Variables

Edit `default.tfvars` with your environment-specific values:

```hcl
# AWS Configuration
aws_region  = "us-east-2"
aws_profile = "your-profile"

# Team Information
team_name          = "your-team"
asset_owner_name   = "Your Name"
environment        = "dev"

# CyberArk Configuration
identity_tenant_id       = "your-tenant"
identity_username        = "your-user@example.com"
identity_password        = "your-password"
sia_connector_pool_name  = "your-connector-pool"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan -var-file=default.tfvars
```

### 5. Deploy Infrastructure

```bash
terraform apply -var-file=default.tfvars
```

## Module Documentation

### Network Modules

#### VPC ([modules/infra/network/vpc](modules/infra/network/vpc))

Creates a complete VPC infrastructure including:

- VPC with configurable CIDR block (default: 192.168.0.0/16)
- Public subnet (192.168.200.0/24) in us-east-2a
- Private subnet (192.168.201.0/24) in us-east-2b
- Internet Gateway for public internet access
- NAT Gateway with Elastic IP for private subnet outbound traffic
- Route tables with proper subnet associations
- S3 Gateway VPC endpoint for secure S3 access
- Custom DHCP options with domain controller DNS

**Key Outputs:**
- `vpc_id`
- `public_subnet_id`
- `private_subnet_id`
- `nat_gateway_id`

#### Security Groups ([modules/infra/network/security_groups](modules/infra/network/security_groups))

Defines security groups for:

- External SSH access (port 22) from trusted IPs
- External RDP access (port 3389) from trusted IPs
- Internal SSH access within VPC
- Internal RDP access within VPC
- Internal WinRM access (port 5985)
- MySQL access (port 3306) from private subnets only
- Domain Controller (comprehensive AD/DNS ports: 53, 88, 389, 445, 3268, etc.)

**Key Outputs:**
- `ssh_ext_sg_id`
- `rdp_ext_sg_id`
- `mysql_sg_id`
- `dc_sg_id`

#### MySQL Subnet Group ([modules/infra/network/subnets/database/rds/mysql_subnet_group](modules/infra/network/subnets/database/rds/mysql_subnet_group))

Creates a DB subnet group spanning both public and private subnets for RDS deployment.

### Compute Modules

#### Linux Connector ([modules/infra/compute/ec2/connectors/linux_connector](modules/infra/compute/ec2/connectors/linux_connector))

Provisions an Ubuntu 24.04 LTS EC2 instance configured as a CyberArk SIA connector.

**Features:**
- Deployed in private subnet (no public IP)
- Instance type: t3.micro (configurable)
- Automated setup via user data script:
  - System package updates
  - Script download from S3
  - CyberArk connector registration
  - Environment variable configuration

**Requirements:**
- S3 read-only IAM role
- Private subnet
- SSH security group
- SSH key pair

#### Linux Target ([modules/infra/compute/ec2/targets/linux_target](modules/infra/compute/ec2/targets/linux_target))

Provisions an Ubuntu 24.04 LTS EC2 instance configured as a CyberArk-managed target system.

**Features:**
- Similar configuration to Linux Connector
- Retrieves Conjur credentials for authentication
- Configured as SIA workspace target
- Automated initialization and configuration scripts

### Database Modules

#### MySQL RDS ([modules/infra/database/rds/mysql](modules/infra/database/rds/mysql))

Creates an AWS RDS MySQL instance for application data.

**Specifications:**
- Instance class: db.t4g.micro (configurable)
- Allocated storage: 10GB (GP2)
- Database name: "music"
- Multi-AZ: disabled (dev environment)
- Not publicly accessible
- Credentials managed via Conjur

**Security:**
- Deployed in DB subnet group
- MySQL security group restricts access to private subnets only
- Skip final snapshot enabled for development

### Storage Modules

#### S3 Bucket ([modules/infra/storage/s3](modules/infra/storage/s3))

Creates a secure S3 bucket for deployment scripts.

**Features:**
- Bucket name: `pineapple-dev-bucket`
- All public access blocked
- Access restricted to:
  - VPC endpoint (S3 gateway)
  - Specific IP addresses
- Automated script synchronization from `../scripts` directory
- MD5-based change detection for updates

**Bucket Policy:**
- Enforces VPC endpoint or IP-based access
- Follows principle of least privilege

### Security Modules

#### Key Pair ([modules/security/key_pair](modules/security/key_pair))

Generates an RSA 4096-bit SSH key pair for EC2 instance access.

**Outputs:**
- AWS key pair name
- Private key exported as local .pem file (`.gitignore`d)

#### S3 Read-Only IAM Role ([modules/security/roles/ec2/s3_ro_role](modules/security/roles/ec2/s3_ro_role))

Creates an IAM role with EC2 trust policy and S3 read-only permissions.

**Permissions:**
- `s3:GetObject` - Download scripts from S3
- `s3:ListBucket` - List bucket contents

**Outputs:**
- IAM role ARN
- Instance profile name for EC2 attachment

## Configuration

### Variable Reference

#### AWS Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region for deployment | `us-east-2` |
| `aws_profile` | AWS CLI profile name | `AdministratorAccess-475601244925` |
| `availability_zone_1` | First availability zone | `us-east-2a` |
| `availability_zone_2` | Second availability zone | `us-east-2b` |

#### Network Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `vpc_cidr` | VPC CIDR block | `192.168.0.0/16` |
| `public_subnet_cidr` | Public subnet CIDR | `192.168.200.0/24` |
| `private_subnet_cidr` | Private subnet CIDR | `192.168.201.0/24` |
| `trusted_ips` | Trusted IPs for external access | `["137.83.221.69/32"]` |
| `allowed_ips` | Allowed IPs for S3 access | `["137.83.221.69/32"]` |

#### Compute Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `instance_type` | EC2 instance type | `t3.micro` |
| `linux_connector_hostname` | Linux connector hostname | `linux-connector` |
| `linux_target_hostname` | Linux target hostname | `linux-target` |

#### CyberArk Settings

| Variable | Description |
|----------|-------------|
| `identity_tenant_id` | CyberArk Identity tenant ID |
| `identity_username` | Identity tenant username |
| `identity_password` | Identity tenant password |
| `sia_connector_pool_name` | SIA connector pool name |
| `conjur_appliance_url` | Conjur appliance URL |
| `conjur_account` | Conjur account name |
| `conjur_host_id` | Conjur host identity |
| `conjur_api_key` | Conjur API key |
| `db_username_var` | Conjur variable path for DB username |
| `db_password_var` | Conjur variable path for DB password |

#### Tags & Metadata

| Variable | Description | Default |
|----------|-------------|---------|
| `team_name` | Team name for tagging | `pineapple` |
| `asset_owner_name` | Asset owner name | `Joe Strickland` |
| `environment` | Environment (dev/prod) | `dev` |

## Security

### Security Best Practices

This project implements several security best practices:

1. **Network Isolation**
   - Private subnets for compute and database resources
   - NAT Gateway for controlled outbound internet access
   - No public IPs assigned to sensitive resources

2. **Least Privilege Access**
   - IAM roles with minimal required permissions
   - Security groups with restrictive ingress rules
   - VPC endpoints to avoid internet routing

3. **Secret Management**
   - All credentials stored in CyberArk Conjur
   - No hardcoded secrets in Terraform code
   - Dynamic credential injection at runtime

4. **Encryption**
   - Terraform state encrypted at rest in S3
   - RDS storage encryption (configurable)
   - Secrets encrypted in Conjur

5. **Access Control**
   - S3 bucket public access blocking
   - IP-based access restrictions
   - Multi-factor authentication for AWS access

### Sensitive Data

The following files contain sensitive data and should **never** be committed to version control:

- `*.pem` - SSH private keys
- `*.tfvars` (except `default.tfvars` template)
- `.terraform/` - Terraform plugins and modules
- `terraform.tfstate*` - State files (stored in S3)

Ensure your `.gitignore` file includes these patterns.

## Deployment

### Initial Deployment

1. **Configure Backend**: Ensure S3 bucket and DynamoDB table exist:

```bash
# Create S3 bucket for state (if not exists)
aws s3 mb s3://pineapple.dev --region us-east-2

# Create DynamoDB table for locking (if not exists)
aws dynamodb create-table \
  --table-name pineapple-terraform-lock-table \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-2
```

2. **Initialize Terraform**:

```bash
terraform init -backend-config="profile=AdministratorAccess-475601244925"
```

3. **Validate Configuration**:

```bash
terraform validate
terraform fmt -recursive
```

4. **Plan Deployment**:

```bash
terraform plan -var-file=default.tfvars -out=tfplan
```

5. **Apply Changes**:

```bash
terraform apply tfplan
```

### Updating Infrastructure

To update existing infrastructure:

```bash
# Pull latest state
terraform refresh -var-file=default.tfvars

# Review changes
terraform plan -var-file=default.tfvars

# Apply updates
terraform apply -var-file=default.tfvars
```

### Destroying Infrastructure

To tear down all resources:

```bash
terraform destroy -var-file=default.tfvars
```

**Warning**: This will permanently delete all infrastructure. Ensure you have backups of any important data.

## Troubleshooting

### Common Issues

#### Issue: "Error acquiring state lock"

**Cause**: Previous Terraform operation was interrupted, leaving a lock in DynamoDB.

**Solution**:
```bash
# Force unlock (use the Lock ID from error message)
terraform force-unlock <LOCK_ID>
```

#### Issue: "Error creating EC2 instance: UnauthorizedOperation"

**Cause**: Insufficient AWS permissions.

**Solution**: Ensure your AWS profile has the necessary IAM permissions. Review the IAM policy requirements in the AWS provider documentation.

#### Issue: "Error: Invalid provider configuration"

**Cause**: Missing or incorrect Conjur credentials.

**Solution**: Verify the following variables are set correctly:
- `conjur_appliance_url`
- `conjur_account`
- `conjur_host_id`
- `conjur_api_key`

#### Issue: SSH connection refused to EC2 instances

**Cause**: Security group rules or instance not fully initialized.

**Solutions**:
1. Verify security group allows SSH from your IP
2. Ensure instance is in "running" state
3. Check NAT Gateway for private instances
4. Verify SSH key pair matches

#### Issue: S3 script synchronization fails

**Cause**: IAM permissions or S3 bucket policy issues.

**Solution**:
1. Verify S3 bucket policy allows access from your IP/VPC endpoint
2. Check IAM role has `s3:PutObject` permissions
3. Ensure `../scripts` directory exists and contains files

### Debug Mode

Enable detailed logging:

```bash
export TF_LOG=DEBUG
terraform apply -var-file=default.tfvars
```

To save logs to a file:

```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform-debug.log
terraform apply -var-file=default.tfvars
```

### Getting Help

- Check Terraform documentation: https://www.terraform.io/docs
- Review AWS provider docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- CyberArk Conjur: https://docs.cyberark.com/conjur-cloud

## Backend Configuration

Terraform state is stored remotely in S3 with DynamoDB state locking:

```hcl
Backend:
  Type: s3
  Bucket: pineapple.dev
  Key: terraform/terraform.tfstate
  Region: us-east-2
  DynamoDB Table: pineapple-terraform-lock-table
  Encryption: Enabled
  Profile: AdministratorAccess-475601244925
```

**Benefits:**
- Team collaboration with shared state
- State locking prevents concurrent modifications
- Encryption at rest for sensitive data
- Version history and rollback capability

## Contributing

When modifying this infrastructure:

1. Create a feature branch
2. Make changes and test locally
3. Run `terraform fmt -recursive` to format code
4. Run `terraform validate` to check syntax
5. Create a plan and review changes
6. Submit a pull request with detailed description

## License

[Add your license information here]

## Contact

**Project Owner**: Joe Strickland
**Team**: Pineapple
**Environment**: Development

For questions or issues, please contact the infrastructure team or open an issue in the repository.
