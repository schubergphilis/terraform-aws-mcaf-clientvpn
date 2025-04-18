locals {
  create_certificate = var.server_certificate == null
  certificate_arn    = local.create_certificate ? aws_acm_certificate.default[0].arn : data.aws_acm_certificate.current[0].arn
  certificate_name   = replace(var.name, " ", "-")
}

data "aws_route53_zone" "current" {
  count = local.create_certificate ? 1 : 0

  zone_id = var.zone_id
}

data "aws_acm_certificate" "current" {
  count = local.create_certificate ? 0 : 1

  domain = var.server_certificate
}

resource "aws_acm_certificate" "default" {
  count = local.create_certificate ? 1 : 0

  domain_name       = "${local.certificate_name}.${data.aws_route53_zone.current[0].name}"
  validation_method = "DNS"
  tags              = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "default" {
  count = local.create_certificate ? 1 : 0

  certificate_arn         = aws_acm_certificate.default[0].arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}

resource "aws_route53_record" "certificate_validation" {
  for_each = local.create_certificate ? {
    for dvo in aws_acm_certificate.default[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.current[0].zone_id
}
