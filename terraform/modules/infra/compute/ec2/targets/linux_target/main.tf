data "aws_ami" "ubuntu_24_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] # Canonical's AWS account ID
}

resource "aws_instance" "linux_target" {
  ami                         = data.aws_ami.ubuntu_24_04.id
  instance_type               = var.linux_instance_type
  subnet_id                   = var.private_subnet_id
  associate_public_ip_address = false
  key_name                    = var.key_name
  vpc_security_group_ids      = var.linux_security_group_ids
  iam_instance_profile        = var.ec2_s3_ro_instance_profile_name

  user_data = <<-EOF
    #!/bin/bash -xe

    apt-get update -y
    snap install aws-cli --classic

    # Export variables for scripts
    export IDENTITY_TENANT_ID="${var.identity_tenant_id}"
    export PLATFORM_TENANT_NAME="${var.platform_tenant_name}"
    export WORKSPACE_ID="${var.workspace_id}"
    export WORKSPACE_TYPE="${var.workspace_type}"
    export AWS_ROLE_NAME="${var.aws_role_name}"
    export SERVICE_ID="${var.service_id}"
    export HOST_ID="${var.host_id}"
    export USERNAME_VARIABLE="${var.username_variable}"
    export PASSWORD_VARIABLE="${var.password_variable}"

    SSHD_DIR=/var/run/sshd
    SCRIPTS_DIR=/opt/sia
    mkdir -p "$SCRIPTS_DIR"
    mkdir -p "$SSHD_DIR"

    aws s3 cp s3://${var.s3_bucket_name}/${var.s3_bucket_path} "$SCRIPTS_DIR" --recursive

    # make scripts executable
    chmod +x "$SCRIPTS_DIR"/*.sh

    # run them
    "$SCRIPTS_DIR/01_init.sh" "${var.linux_hostname}"
    "$SCRIPTS_DIR/02_configure_target.sh"
  EOF

  tags = {
    Name  = var.name
    Owner = var.asset_owner_name
    CA_iScheduler = var.iScheduler
    CA_iCreator_CreatorBy = var.iCreator_CreatorBy
  }

  lifecycle {
    ignore_changes = [ tags ]
  }
}