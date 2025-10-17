data "aws_caller_identity" "current" {
}

module "vpc" {
  source              = "./modules/infra/network/vpc"
  region              = var.aws_region
  environment         = var.environment
  asset_owner_name    = var.asset_owner_name
  team_name           = var.team_name
  private_subnet_az   = var.private_subnet_az
  public_subnet_az    = var.public_subnet_az
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  domain_name         = "${var.team_name}.${var.environment}"
  dns_server_ip       = var.dc1_private_ip
}

module "s3_bucket" {
  source             = "./modules/infra/storage/s3"
  aws_region         = var.aws_region
  aws_profile        = var.aws_profile
  asset_owner_name   = var.asset_owner_name
  bucket_name        = "${var.team_name}-${var.environment}-bucket"
  s3_vpc_endpoint_id = module.vpc.s3_vpc_endpoint_id
  allowed_ips        = var.allowed_ips
}

module "key_pair" {
  source           = "./modules/security/key_pair"
  server_key_name  = "${var.team_name}-key"
  team_name        = var.team_name
  asset_owner_name = var.asset_owner_name
}

module "s3_ro_role" {
  source            = "./modules/security/roles/ec2/s3_ro_role"
  ec2_aws_role_name = "${var.team_name}-ec2-s3-ro-role"
  s3_arn            = [module.s3_bucket.bucket_arn, "${module.s3_bucket.bucket_arn}/*"]
  team_name         = var.team_name
}

module "security_groups" {
  source              = "./modules/infra/network/security_groups"
  asset_owner_name    = var.asset_owner_name
  vpc_id              = module.vpc.vpc_id
  trusted_ips         = var.trusted_ips
  team_name           = var.team_name
  internal_subnets    = ["${var.public_subnet_cidr}", "${var.private_subnet_cidr}"]
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr  = var.public_subnet_cidr
}
/*
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
*/
module "linux_target" {
  source                          = "./modules/infra/compute/ec2/targets/linux_target"
  iCreator_CreatorBy              = var.iCreator_CreatorBy
  environment                     = var.environment
  team_name                       = var.team_name
  name                            = "${var.team_name}-linux-target"
  asset_owner_name                = var.asset_owner_name
  key_name                        = module.key_pair.key_name
  iScheduler                      = var.iScheduler
  linux_security_group_ids        = [module.security_groups.ssh_internal_flat_sg_id]
  private_subnet_id               = module.vpc.private_subnet_id
  linux_hostname                  = var.linux_hostname
  linux_instance_type             = var.linux_instance_type
  s3_bucket_name                  = module.s3_bucket.bucket_name
  s3_bucket_path                  = var.ubuntu_scripts_s3_bucket_path
  ec2_s3_ro_instance_profile_name = module.s3_ro_role.profile_name
  aws_role_name                   = "${var.team_name}-ec2-s3-ro-role"
  username_variable               = var.username_variable
  password_variable               = var.password_variable
  service_id                      = var.service_id
  host_id                         = var.host_id
  platform_tenant_name            = var.platform_tenant_name
  identity_tenant_id              = var.identity_tenant_id
  workspace_id                    = var.workspace_id
  workspace_type                  = var.workspace_type
}

/*
module "mysql_subnet_group" {
  source             = "./modules/infra/network/subnets/database/rds/mysql_subnet_group"
  team_name          = var.team_name
  environment        = var.environment
  asset_owner_name   = var.asset_owner_name
  private_subnet_ids = [module.vpc.private_subnet_id, module.vpc.public_subnet_id]
}

module "mysql" {
  source                 = "./modules/infrastructure/rds/mysql"
  name                   = "${var.team_name}-mysql"
  iScheduler             = var.iScheduler
  environment            = "${var.team_name}-${var.environment}"
  db_subnet_group_name   = module.mysql_subnet_group.mysql_subnet_group_name
  asset_owner_name       = var.asset_owner_name
  vpc_security_group_ids = [module.security_groups.mysql_target_sg_id]
}*/
