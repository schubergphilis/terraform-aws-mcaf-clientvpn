output "endpoint_id" {
  value = aws_ec2_client_vpn_endpoint.default.id
}

output "security_group_id" {
  value = aws_security_group.default.id
}

output "self_signed_cert_body_pem" {
  value = var.authentication_type == local.certificate_authentication ? aws_acm_certificate.self_signed[0].certificate_body : null
}


