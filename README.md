# terraform-aws-mcaf-clientvpn

Terraform module to create a managed AWS Client VPN endpoint and Okta app for authentication.

> [!NOTE]
> If creating more than one VPN endpoint, be sure to configure `var.cloudwatch_log_group_name`
> with a unique name for cluster, otherwise all VPN endpoints will log to the same CloudWatch log group.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_okta"></a> [okta](#requirement\_okta) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_okta"></a> [okta](#provider\_okta) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudwatch_log_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_ec2_client_vpn_authorization_rule.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_endpoint.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint) | resource |
| [aws_ec2_client_vpn_network_association.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association) | resource |
| [aws_ec2_client_vpn_route.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route) | resource |
| [aws_iam_saml_provider.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_saml_provider) | resource |
| [aws_route53_record.certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [okta_app_bookmark.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_bookmark) | resource |
| [okta_app_group_assignment.bookmark](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_group_assignment) | resource |
| [okta_app_group_assignment.saml_app](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_group_assignment) | resource |
| [okta_app_saml.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_saml) | resource |
| [aws_acm_certificate.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_route53_zone.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_cidr_block"></a> [client\_cidr\_block](#input\_client\_cidr\_block) | The CIDR to use for the clients | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key to use for encryption | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs to associate with the Client VPN endpoint | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The ID of the subnets to associate with the Client VPN endpoint | `list(string)` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | ID of the Route53 zone in which to create the subdomain record | `string` | n/a | yes |
| <a name="input_cloudwatch_retention_in_days"></a> [cloudwatch\_retention\_in\_days](#input\_cloudwatch\_retention\_in\_days) | The number of days to retain logs in CloudWatch | `string` | `"365"` | no |
| <a name="input_connection_logging"></a> [connection\_logging](#input\_connection\_logging) | Indicates whether connection logging is enabled | `bool` | `true` | no |
| <a name="input_create_okta_bookmark"></a> [create\_okta\_bookmark](#input\_create\_okta\_bookmark) | Indicates whether to create an Okta bookmark for the self-service portal | `bool` | `true` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | DNS resolvers to configure (max 2) | `list(string)` | `null` | no |
| <a name="input_enable_self_service_portal"></a> [enable\_self\_service\_portal](#input\_enable\_self\_service\_portal) | Specify whether to enable the self-service portal for the Client VPN endpoint | `bool` | `true` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | The name of the CloudWatch log group to which the connection logs will be published | `string` | `"/aws/clientvpn"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name for the Client VPN | `string` | `"Client VPN"` | no |
| <a name="input_name_in_okta_label"></a> [name\_in\_okta\_label](#input\_name\_in\_okta\_label) | Indicates whether to include the endpoint name in the Okta label | `bool` | `false` | no |
| <a name="input_okta_app_authentication_policy_id"></a> [okta\_app\_authentication\_policy\_id](#input\_okta\_app\_authentication\_policy\_id) | ID of the sign-on policy to be associated with the Okta app | `string` | `null` | no |
| <a name="input_okta_group_ids"></a> [okta\_group\_ids](#input\_okta\_group\_ids) | List of Okta group IDs to have the VPN assigned | `list(string)` | `[]` | no |
| <a name="input_okta_label"></a> [okta\_label](#input\_okta\_label) | The label applied to the Okta app and bookmark | `string` | `"AWS Client VPN"` | no |
| <a name="input_server_certificate"></a> [server\_certificate](#input\_server\_certificate) | The domain name of the server certificate | `string` | `null` | no |
| <a name="input_split_tunnel"></a> [split\_tunnel](#input\_split\_tunnel) | Indicates whether split-tunnel is enabled on VPN endpoint | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources in this module | `map(string)` | `null` | no |
| <a name="input_transport_protocol"></a> [transport\_protocol](#input\_transport\_protocol) | The transport protocol to be used by the VPN session | `string` | `"udp"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | The DNS name of the Client VPN endpoint |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Client VPN endpoint |
<!-- END_TF_DOCS -->

## License

**Copyright:** Schuberg Philis

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
