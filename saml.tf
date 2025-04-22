resource "aws_iam_saml_provider" "default" {
  name                   = "Okta-${var.name}-ClientVPN"
  saml_metadata_document = okta_app_saml.default.metadata
}

resource "okta_app_saml" "default" {
  app_settings_json     = "{\"port\": 35001}"
  authentication_policy = var.okta_app_authentication_policy_id
  hide_ios              = true
  hide_web              = true
  label                 = var.name_in_okta_label ? format("%s (%s)", var.okta_label, var.name) : var.okta_label
  preconfigured_app     = "aws_clientvpn"
}

resource "okta_app_group_assignment" "saml_app" {
  for_each = toset(var.okta_group_ids)

  app_id   = okta_app_saml.default.id
  group_id = each.key
}

resource "okta_app_bookmark" "default" {
  count = var.create_okta_bookmark ? 1 : 0

  label = var.name_in_okta_label ? format("%s (%s)", var.okta_label, var.name) : var.okta_label
  logo  = "${path.module}/logo.png"
  url   = aws_ec2_client_vpn_endpoint.default.self_service_portal_url
}

resource "okta_app_group_assignment" "bookmark" {
  for_each = var.create_okta_bookmark ? toset(var.okta_group_ids) : []

  app_id   = okta_app_bookmark.default[0].id
  group_id = each.key
}
