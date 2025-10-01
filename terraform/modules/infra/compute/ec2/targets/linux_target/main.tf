data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] # cannonical
}

resource "aws_instance" "linux_target" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.linux_instance_type
  subnet_id                   = var.private_subnet_id
  associate_public_ip_address = false
  key_name                    = var.key_name
  vpc_security_group_ids      = var.linux_security_group_ids

  tags = {
    Name  = var.name
    Owner = var.asset_owner_name
    CA_iScheduler = var.iScheduler
    CA_iCreateor_CreatorBy = var.iCreateor_CreatorBy
  }

  lifecycle {
    ignore_changes = [ tags ]
  }
}