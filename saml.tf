resource "aws_iam_saml_provider" "default" {
  name                   = "Okta-${var.stack}-ClientVPN"
  saml_metadata_document = okta_app_saml.default.metadata
}

resource "okta_app_saml" "default" {
  app_settings_json = "{\"port\": 35001}"
  hide_ios          = true
  hide_web          = true
  label             = var.okta_label
  preconfigured_app = "aws_clientvpn"

  lifecycle {
    ignore_changes = [users, groups]
  }
}

resource "okta_app_group_assignment" "default" {
  for_each = toset(var.okta_groups)

  app_id   = okta_app_saml.default.id
  group_id = each.key

  lifecycle {
    ignore_changes = [priority]
  }
}
