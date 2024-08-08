output "dns_name" {
  description = "The DNS name of the Client VPN endpoint"
  value       = aws_ec2_client_vpn_endpoint.default.dns_name
}

output "id" {
  description = "The ID of the Client VPN endpoint"
  value       = aws_ec2_client_vpn_endpoint.default.id
}

output "security_group_id" {
  description = "Security group ID attached to the Client VPN endpoint"
  value       = aws_security_group.default.id
}
