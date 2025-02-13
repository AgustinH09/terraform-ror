output "instance_ids" {
  value       = aws_instance.ec2.*.id
  description = "List of IDs of EC2 instances"
}

output "instance_public_ips" {
  value       = aws_instance.ec2.*.public_ip
  description = "Public IP addresses of EC2 instances"
}

output "instance_private_ips" {
  value       = aws_instance.ec2.*.private_ip
  description = "Private IP addresses of EC2 instances"
}

output "security_group_id" {
  value       = aws_security_group.sg.id
  description = "The ID of the security group assigned to the EC2 instances"
}

output "key_pair_name" {
  value       = aws_key_pair.key.key_name
  description = "The name of the key pair used for the EC2 instances"
}
