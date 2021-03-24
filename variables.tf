variable "authentication_type" {
  type        = string
  description = "Type of authentication used"

  validation {
    condition     = anytrue([var.authentication_type == "certificate-authentication", var.authentication_type == "federated-authentication"])
    error_message = "Must be either 'federated-authentication' or 'certificate-authentication'."
  }
}

variable "client_cidr_block" {
  type        = string
  description = "The CIDR to use for the clients"
}

variable "connection_logging" {
  type        = bool
  default     = true
  description = "Indicates whether connection logging is enabled"
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "A Client VPN endpoint can have up to two DNS servers"
}

variable "federated_authentication" {
  type = object({
    okta_groups = list(string)
    okta_label  = string
  })
  default     = null
  description = "Implements Federated Athentication using OKTA. Required when var.authentication_type is 'federated-authentication'"
}

variable "certificate_authentication" {
  type = object({
    organization    = string
    private_key_pem = string
  })
  default     = null
  description = "Implements Certificate (Mutual) Authentication using self-signed certificates. Required when var.authentication_type is 'certificate-authentication'"
}

variable "split_tunnel" {
  type        = bool
  default     = true
  description = "Indicates whether split-tunnel is enabled on VPN endpoint"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The ID of the subnets to associate with the Client VPN endpoint"
}

variable "stack" {
  type        = string
  description = "The stack name for the client vpn"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resources in this module"
}

variable "transport_protocol" {
  type        = string
  default     = "udp"
  description = "The transport protocol to be used by the VPN session"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to which the Client VPN is associated"
}

variable "zone_id" {
  type        = string
  description = "ID of the Route53 zone in which to create the subdomain record"
}
