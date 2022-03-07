locals {
  dns_name = "${var.stack}.${data.aws_route53_zone.current.name}"
}

data "aws_route53_zone" "current" {
  zone_id = var.zone_id
}

resource "aws_route53_record" "default" {
  count = var.authentication_type == local.federated_authentication ? 1 : 0

  zone_id = var.zone_id
  name    = local.dns_name
  type    = "CNAME"
  ttl     = "5"
  records = [aws_ec2_client_vpn_endpoint.default.dns_name]
}

# For "federated-authentication" generate a AWS managed certificate
resource "aws_acm_certificate" "default" {
  count = var.authentication_type == local.federated_authentication ? 1 : 0

  domain_name       = local.dns_name
  validation_method = "DNS"
  tags              = var.tags

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Pending https://github.com/terraform-providers/terraform-provider-aws/issues/14447
# workaround -> https://github.com/terraform-providers/terraform-provider-aws/issues/14447#issuecomment-668766123
resource "aws_route53_record" "certificate_validation" {
  count = var.authentication_type == local.federated_authentication ? 1 : 0

  name    = aws_acm_certificate.default[0].domain_validation_options.*.resource_record_name[0]
  records = [aws_acm_certificate.default[0].domain_validation_options.*.resource_record_value[0]]
  ttl     = 60
  type    = aws_acm_certificate.default[0].domain_validation_options.*.resource_record_type[0]
  zone_id = var.zone_id
}

resource "aws_acm_certificate_validation" "default" {
  count = var.authentication_type == local.federated_authentication ? 1 : 0

  certificate_arn         = aws_acm_certificate.default[0].arn
  validation_record_fqdns = [aws_route53_record.certificate_validation[0].fqdn]
}
