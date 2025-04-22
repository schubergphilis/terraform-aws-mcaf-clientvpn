data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

resource "aws_cloudwatch_log_group" "default" {
  name              = var.log_group_name
  kms_key_id        = var.kms_key_arn
  retention_in_days = var.cloudwatch_retention_in_days
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "default" {
  log_group_name = aws_cloudwatch_log_group.default.name
  name           = var.name
}

resource "aws_ec2_client_vpn_endpoint" "default" {
  client_cidr_block      = var.client_cidr_block
  description            = var.name
  dns_servers            = var.dns_servers
  security_group_ids     = var.security_group_ids
  self_service_portal    = var.enable_self_service_portal ? "enabled" : "disabled"
  server_certificate_arn = local.certificate_arn
  split_tunnel           = var.split_tunnel
  transport_protocol     = var.transport_protocol
  vpc_id                 = data.aws_subnet.selected.vpc_id
  tags                   = merge(var.tags, { "Name" = var.name })

  authentication_options {
    type              = "federated-authentication"
    saml_provider_arn = aws_iam_saml_provider.default.arn
  }

  connection_log_options {
    enabled               = var.connection_logging
    cloudwatch_log_group  = aws_cloudwatch_log_group.default.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.default.name
  }

  depends_on = [aws_acm_certificate_validation.default]
}

resource "aws_ec2_client_vpn_network_association" "default" {
  count = length(var.subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  subnet_id              = var.subnet_ids[count.index]
}

resource "aws_ec2_client_vpn_route" "default" {
  count = length(var.subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.default[count.index].subnet_id
}

resource "aws_ec2_client_vpn_authorization_rule" "default" {
  authorize_all_groups   = true
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  description            = "Authorization rule for the Client VPN"
  target_network_cidr    = "0.0.0.0/0"
}
