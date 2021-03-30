locals {
  federated_authentication   = "federated-authentication"
  certificate_authentication = "certificate-authentication"
}

resource "aws_cloudwatch_log_group" "default" {
  name = "/aws/clientvpn/${var.stack}"
  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "default" {
  log_group_name = aws_cloudwatch_log_group.default.name
  name           = var.stack
}

resource "aws_ec2_client_vpn_endpoint" "default" {
  client_cidr_block      = var.client_cidr_block
  server_certificate_arn = try(aws_acm_certificate.server[0].arn, aws_acm_certificate.default[0].arn)
  split_tunnel           = var.split_tunnel
  description            = var.stack
  dns_servers            = var.dns_servers
  tags                   = merge(var.tags, { "Name" = local.dns_name })
  transport_protocol     = var.transport_protocol

  authentication_options {
    type                       = var.authentication_type
    root_certificate_chain_arn = try(aws_acm_certificate.root[0].arn, null)
    saml_provider_arn          = try(aws_iam_saml_provider.default[0].arn, null)
  }

  connection_log_options {
    enabled               = var.connection_logging
    cloudwatch_log_group  = aws_cloudwatch_log_group.default.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.default.name
  }
}

resource "aws_ec2_client_vpn_network_association" "default" {
  for_each = toset(var.subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  subnet_id              = each.key
  security_groups        = [aws_security_group.default.id]
}

resource "aws_security_group" "default" {
  name        = "${var.stack}-sg"
  description = "Security group for the Client VPN - ${var.stack}"
  vpc_id      = var.vpc_id
  tags        = var.tags

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_ec2_client_vpn_authorization_rule" "default" {
  authorize_all_groups   = true
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  description            = "Authorization rule for the Client VPN"
  target_network_cidr    = "0.0.0.0/0"
}
