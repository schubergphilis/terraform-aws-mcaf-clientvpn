variable "client_cidr_block" {
  type        = string
  description = "The CIDR to use for the clients"
}

variable "connection_logging" {
  type        = bool
  default     = true
  description = "Indicates whether connection logging is enabled"
}

variable "create_okta_bookmark" {
  type        = bool
  default     = true
  description = "Indicates whether to create an Okta bookmark for the self-service portal"
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "DNS resolvers to configure (max 2)"

  validation {
    condition     = length(var.dns_servers) <= 2
    error_message = "A Client VPN endpoint can have up to two DNS servers"
  }
}

variable "enable_self_service_portal" {
  type        = bool
  default     = true
  description = "Specify whether to enable the self-service portal for the Client VPN endpoint"
}

variable "name" {
  type        = string
  description = "The name for the Client VPN"
}

variable "okta_groups" {
  type        = list(string)
  default     = []
  description = "List of Okta group IDs to have the VPN assigned"
}

variable "okta_label" {
  type        = string
  default     = "Client VPN"
  description = "The label of the Okta App"
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

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resources in this module"
  default     = null
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
