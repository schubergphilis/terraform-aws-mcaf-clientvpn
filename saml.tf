resource "aws_iam_saml_provider" "default" {
  name                   = "Okta-${var.stack}-ClientVPN"
  saml_metadata_document = okta_app_saml.default.metadata
}

resource "okta_app_saml" "default" {
  label             = var.okta_label
  preconfigured_app = "aws_clientvpn"
  app_settings_json = "{\"port\": 35001}"
  lifecycle {
    ignore_changes = [users, groups]
  }
}

resource "okta_app_group_assignment" "default" {
  for_each = toset(var.okta_groups)

  app_id   = okta_app_saml.default.id
  group_id = each.key
}
