# terraform-aws-mcaf-clientvpn
Terraform module to create and manage a [Client VPN Endpoint](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-working-endpoints.html).

- Create a Client VPN endpoint to connect to resources in a VPC with a VPC client: presumably the [AWS Client VPN](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/connect-aws-client-vpn-connect.html)
or [OpenVPN client](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/connect.html).
  
### Authentication
Currently the Client VPN Endpoint supports either:

- 'federated-authentication' using OKTA as the 'SAML' identity provider.
- 'mutual-authentication' with self-signed certificates.



```terraform
module "clientvpn" {
  source                   = "github.com/schubergphilis/terraform-aws-mcaf-clientvpn"

  authentication_type = "federated-authentication"
  client_cidr_block   = "10.0.0.0/20"
  dns_servers         = [10.0.0.2] 
  stack               = "example"
  subnet_ids          = ["subnet-xxxyyyzzz"] 
  tags                = { name = "example" }
  vpc_id              = "vpc-xxyyzz"

  federated_authentication = {
    okta_groups = ["group-xxyyzz"]
    okta_label  = "example"
    zone_id     = "aaabbbccc1234"
  }
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.5.0 |
| okta | >= 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.5.0 |
| okta | >= 3.5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_cidr\_block | The CIDR to use for the clients | `string` | n/a | yes |
| stack | The stack name for the client vpn | `string` | n/a | yes |
| subnet\_ids | The ID of the subnets to associate with the Client VPN endpoint | `list(string)` | n/a | yes |
| tags | A mapping of tags to assign to the resources in this module | `map(string)` | n/a | yes |
| vpc\_id | The ID of the VPC to which the Client VPN is associated | `string` | n/a | yes |
| zone\_id | ID of the Route53 zone in which to create the subdomain record | `string` | n/a | yes |
| connection\_logging | Indicates whether connection logging is enabled | `bool` | `true` | no |
| dns\_servers | A Client VPN endpoint can have up to two DNS servers | `list(string)` | `null` | no |
| okta\_groups | List of Okta group IDs to have the VPN assigned | `list(string)` | `[]` | no |
| okta\_label | The label of the Okta App | `string` | `"Client VPN"` | no |
| split\_tunnel | Indicates whether split-tunnel is enabled on VPN endpoint | `bool` | `true` | no |
| transport\_protocol | The transport protocol to be used by the VPN session | `string` | `"udp"` | no |

## Outputs

| Name | Description |
|------|-------------|
| endpoint\_id | n/a |
| security\_group\_id | n/a |

<!--- END_TF_DOCS --->
