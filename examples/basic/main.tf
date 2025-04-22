data "aws_route53_zone" "current" {
  zone_id = "Z0123456789ABCDEFGHIJ"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "clientvpn-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "kms" {
  source  = "schubergphilis/mcaf-kms/aws"
  version = "0.3.0"

  name = "MyClientVPN"
}

module "security_group" {
  source  = "schubergphilis/mcaf-security-group/aws"
  version = "~> 2.0"

  name_prefix = "MyClientVPN-sg-"
  description = "Security group for the MyClientVPN Client VPN"
  vpc_id      = module.vpc.vpc_id

  egress_rules = {
    allow_all = {
      cidr_ipv4   = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  }
}

module "clientvpn" {
  source = "../.."

  name               = "MyClientVPN"
  client_cidr_block  = "172.16.0.0/16"
  dns_servers        = ["8.8.8.8"]
  kms_key_arn        = module.kms.arn
  security_group_ids = [module.security_group.id]
  subnet_ids         = module.vpc.private_subnets
  zone_id            = data.aws_route53_zone.current.zone_id
}
