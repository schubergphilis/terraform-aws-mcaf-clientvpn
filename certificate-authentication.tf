resource "tls_private_key" "ca" {
  count = var.authentication_type == local.certificate_authentication ? 1 : 0

  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  count = var.authentication_type == local.certificate_authentication ? 1 : 0

  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.ca[0].private_key_pem

  subject {
    common_name  = "${var.certificate_authentication["organization"]}.vpn.ca"
    organization = var.certificate_authentication["organization"]
  }

  validity_period_hours = 87600 # ten years
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}

resource "aws_acm_certificate" "ca" {
  count = var.authentication_type == local.certificate_authentication ? 1 : 0

  private_key      = tls_private_key.ca[0].private_key_pem
  certificate_body = tls_self_signed_cert.ca[0].cert_pem
}

resource "tls_private_key" "root" {
  count = var.authentication_type == local.certificate_authentication ? 1 : 0

  algorithm = "RSA"
}

resource "tls_cert_request" "root" {
  count = var.authentication_type == local.certificate_authentication ? 1 : 0

  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.root[0].private_key_pem
  subject {
    common_name  = "${var.certificate_authentication["organization"]}.vpn.client"
    organization = var.certificate_authentication["organization"]
  }
}

resource "tls_locally_signed_cert" "root" {
  count = var.authentication_type == local.certificate_authentication ? 1 : 0

  cert_request_pem   = tls_cert_request.root[0].cert_request_pem
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = tls_private_key.ca[0].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca[0].cert_pem

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}

resource "aws_acm_certificate" "root" {
  count = var.authentication_type == local.certificate_authentication ? 1 : 0

  private_key       = tls_private_key.root[0].private_key_pem
  certificate_body  = tls_locally_signed_cert.root[0].cert_pem
  certificate_chain = tls_self_signed_cert.ca[0].cert_pem
}

resource "tls_private_key" "server" {
  count = var.authentication_type == local.certificate_authentication ? 1 : 0

  algorithm = "RSA"
}

resource "tls_cert_request" "server" {
  count = var.authentication_type == local.certificate_authentication ? 1 : 0

  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.server[0].private_key_pem

  subject {
    common_name  = "${var.certificate_authentication["organization"]}.vpn.client"
    organization = var.certificate_authentication["organization"]
  }
}

resource "tls_locally_signed_cert" "server" {
  count = var.authentication_type == local.certificate_authentication ? 1 : 0

  cert_request_pem   = tls_cert_request.server[0].cert_request_pem
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = tls_private_key.ca[0].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca[0].cert_pem

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "server" {
  count = var.authentication_type == local.certificate_authentication ? 1 : 0

  private_key       = tls_private_key.server[0].private_key_pem
  certificate_body  = tls_locally_signed_cert.server[0].cert_pem
  certificate_chain = tls_self_signed_cert.ca[0].cert_pem
}
