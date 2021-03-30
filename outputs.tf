output "endpoint_id" {
  value = aws_ec2_client_vpn_endpoint.default.id
}

output "root_cert_body_pem" {
  value = var.authentication_type == local.certificate_authentication ? aws_acm_certificate.root[0].certificate_body : null
}

output "root_cert_private_key" {
  value = var.authentication_type == local.certificate_authentication ? aws_acm_certificate.root[0].private_key : null
}

output "security_group_id" {
  value = aws_security_group.default.id
}
