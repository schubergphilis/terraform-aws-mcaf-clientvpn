variable "client_cidr_block" {
  type        = string
  description = "The CIDR to use for the clients"
}

variable "cloudwatch_retention_in_days" {
  type        = string
  default     = "365"
  description = "The number of days to retain logs in CloudWatch"
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

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key to use for encryption"
}

variable "log_group_name" {
  type        = string
  default     = "/aws/clientvpn"
  description = "The name of the CloudWatch log group to which the connection logs will be published"
}

variable "name" {
  type        = string
  default     = "Client VPN"
  description = "The name for the Client VPN"
}

variable "name_in_okta_label" {
  type        = bool
  default     = false
  description = "Indicates whether to include the endpoint name in the Okta label"
}

variable "okta_app_authentication_policy_id" {
  type        = string
  default     = null
  description = "ID of the sign-on policy to be associated with the Okta app"
}

variable "okta_group_ids" {
  type        = list(string)
  default     = []
  description = "List of Okta group IDs to have the VPN assigned"
}

variable "okta_label" {
  type        = string
  default     = "AWS Client VPN"
  description = "The label applied to the Okta app and bookmark"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to associate with the Client VPN endpoint"
}

variable "server_certificate" {
  type        = string
  default     = null
  description = "The domain name of the server certificate"
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

variable "zone_id" {
  type        = string
  description = "ID of the Route53 zone in which to create the subdomain record"
}
