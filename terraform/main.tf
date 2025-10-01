data "aws_caller_identity" "current" {}

module "vpc" {
  source              = "./modules/infra/network/vpc"
  region              = var.region
  asset_owner_name    = var.asset_owner_name
  team_name           = var.team_name
  private_subnet_az   = var.private_subnet_az
  public_subnet_az    = var.public_subnet_az
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  domain_name         = var.domain_name
  dns_server_ip       = var.dc1_private_ip
}

module "s3_bucket" {
  source             = "./modules/infra/storage/s3"
  region             = var.region
  asset_owner_name   = var.asset_owner_name
  bucket_name        = var.team_name
  s3_vpc_endpoint_id = module.vpc.s3_vpc_endpoint_id
}

module "key_pair" {
  source           = "./modules/security/key_pair"
  server_key_name  = "${var.team_name}-key"
  team_name        = var.team_name
  asset_owner_name = var.asset_owner_name
}

module "security_groups" {
  source              = "./modules/networking/security_groups"
  asset_owner_name    = var.asset_owner_name
  vpc_id              = module.vpc.vpc_id
  trusted_ips         = var.trusted_ips
  team_name           = var.team_name
  internal_subnets    = ["${var.public_subnet_cidr}", "${var.private_subnet_cidr}"]
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr  = var.public_subnet_cidr
}

module "cyberark_connectors" {
  source                         = "./modules/infrastructure/ec2_instances/cyberark_connectors"
  vpc_id                         = module.vpc.vpc_id
  team_name                      = var.team_name
  asset_owner_name               = var.asset_owner_name
  windows_ami_id                 = var.amzn_windows_server_ami_id
  key_name                       = module.key_pair.key_name
  iScheduler                     = var.iScheduler
  windows_security_group_ids     = module.security_groups.rdp_internal_flat_sg_id
  private_subnet_id              = module.vpc.private_subnet_id
  connector_1_private_ip         = var.connector_1_private_ip
  sia_aws_connector_1_private_ip = var.sia_aws_connector_1_private_ip
}

module "linux_conector" {
  source                         = "./modules/infra/compute/ec2/connectors/linux_connector"
  private_subnet_id              = module.vpc.private_subnet_id
  key_name                       = module.key_pair.key_name
  team_name                      = var.team_name
  linux_security_group_ids       = module.security_groups.ssh_internal_flat_sg_id
  vpc_id                         = module.vpc.vpc_id
  linux_ami_id                   = var.amzn_linux_ami_id
  iScheduler                     = var.iScheduler
  asset_owner_name               = var.asset_owner_name
  sia_aws_connector_1_private_ip = var.sia_aws_connector_1_private_ip
  region                         = var.region
  connector_pool_name            = var.connector_pool_name
  cyberark_secret_arn            = var.cyberark_secret_arn
  identity_tenant_id             = var.identity_tenant_id
  platform_tenant_name           = var.platform_tenant_name
  ec2_asm_instance_profile_name  = module.ec2_asm_role.us_ent_east_ec2_asm_instance_profile_name
}

module "linux_target" {
  source                        = "./modules/infra/compute/ec2/targets/linux_target"
  vpc_id                        = module.vpc.vpc_id
  team_name                     = var.team_name
  asset_owner_name              = var.asset_owner_name
  key_name                      = module.key_pair.key_name
  iScheduler                    = var.iScheduler
  linux_ami_id                  = var.amzn_linux_ami_id
  linux_security_group_ids      = module.security_groups.ssh_internal_flat_sg_id
  private_subnet_id             = module.vpc.private_subnet_id
  linux_target_1_private_ip     = var.linux_target_1_private_ip
  region                        = var.region
  cyberark_secret_arn           = var.cyberark_secret_arn
  identity_tenant_id            = var.identity_tenant_id
  platform_tenant_name          = var.platform_tenant_name
  workspace_id                  = data.aws_caller_identity.current.account_id
  workspace_type                = var.workspace_type
  linux_target_1_hostname       = var.linux_target_1_hostname
  ec2_asm_instance_profile_name = module.ec2_asm_role.us_ent_east_ec2_asm_instance_profile_name
}

module "mysql_subnet_group" {
  source             = "./modules/infra/network/subnets/database/rds/mysql_subnet_group"
  team_name          = var.team_name
  private_subnet_ids = [module.vpc.private_subnet_id, module.vpc.public_subnet_id]
}

module "mysql" {
  source                 = "./modules/infrastructure/rds/mysql"
  iScheduler             = var.iScheduler
  db_subnet_group_name   = module.mysql_subnet_group.mysql_subnet_group_name
  asset_owner_name       = var.asset_owner_name
  vpc_security_group_ids = [module.security_groups.mysql_target_sg_id]
}