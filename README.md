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
<!--- END_TF_DOCS --->
