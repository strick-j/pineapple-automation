output "trusted_ssh_external_security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.ssh_from_trusted_ips.id
}

output "trusted_ssh_external_security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.ssh_from_trusted_ips.name
}

output "trusted_rdp_external_security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.rdp_from_trusted_ips.id
}

output "trusted_rdp_external_security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.rdp_from_trusted_ips.name
}

output "ssh_internal_flat_sg_id" {
  description = "The ID of the security group"
  value = aws_security_group.ssh_internal_flat.id
}

output "ssh_internal_flat_sg_name" {
  description = "The name of the security group"
  value = aws_security_group.ssh_internal_flat.name
}

output "rdp_internal_flat_sg_id" {
  description = "The ID of the security group"
  value = aws_security_group.rdp_internal_flat.id
}

output "rdp_internal_flat_sg_name" {
  description = "The name of the security group"
  value = aws_security_group.rdp_internal_flat.name
}

output "mysql_target_sg_id" {
  description = "The id of the security group"
  value = aws_security_group.mysql_target_sg.id
}

output "winrm_internal_flat_sg_id" {
  description = "The id of the security group"
  value = aws_security_group.winrm_internal_flat.id
}