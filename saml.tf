resource "aws_iam_saml_provider" "default" {
  count = var.authentication_type == local.federated_authentication ? 1 : 0

  name                   = "Okta-${var.stack}-ClientVPN"
  saml_metadata_document = okta_app_saml.default[0].metadata
}

resource "okta_app_saml" "default" {
  count = var.authentication_type == local.federated_authentication ? 1 : 0

  app_settings_json = "{\"port\": 35001}"
  hide_ios          = true
  hide_web          = true
  label             = try(var.federated_authentication["okta_label"], null)
  preconfigured_app = "aws_clientvpn"

  lifecycle {
    ignore_changes = [users, groups]
  }
}

resource "okta_app_group_assignment" "default" {
  for_each = try(toset(var.federated_authentication["okta_groups"]), {})

  app_id   = okta_app_saml.default[0].id
  group_id = each.key

  lifecycle {
    ignore_changes = [priority]
  }
}
