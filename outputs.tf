output "endpoint_id" {
  value = aws_ec2_client_vpn_endpoint.default.id
}

output "security_group_id" {
  value = aws_security_group.default.id
}

output "self_signed_cert_body_pem" {
  value = var.authentication_type == local.certificate_authentication ? tls_self_signed_cert.default[0].cert_pem : null
}
