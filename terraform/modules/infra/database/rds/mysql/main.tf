
# Initialize the Conjur provider
provider "conjur" {
  appliance_url = var.conjur_appliance_url
  account = var.conjur_account
  authn_type = var.conjur_authn_type
  service_id = var.conjur_authn_service_id
  host_id = var.conjur_host_id
}

data "conjur_secret" "mysql_username" {
  name = var.mysql_username
}

data "conjur_secret" "mysql_password" {
  name = var.mysql_password
}

data "aws_rds_engine_version" "mysql_latest" {
  engine = "mysql"
}

resource "aws_db_instance" "mysql" {
  identifier             = var.identifier
  engine                 = "mysql"
  engine_version         = data.aws_rds_engine_version.mysql_latest.version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  username               = data.conjur_secret.mysql_username.value
  password               = data.conjur_secret.mysql_password.value
  db_name                = var.db_name
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids

  publicly_accessible    = var.publicly_accessible
  multi_az               = false
  storage_type           = "gp2"
  skip_final_snapshot    = true

   tags = var.tags
}