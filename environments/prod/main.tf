terraform {
  required_version = ">= 1.5.0"
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project     = "multi-env-terraform"
      Environment = "prod"
      ManagedBy   = "Terraform"
    }
  }
}

module "infra" {
  source               = "../../modules/infra"
  name                 = "cloudapp-prod"
  environment_name     = "Production"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  instance_type        = var.instance_type
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  max_size             = var.max_size
}

output "application_url" {
  value = "http://${module.infra.alb_dns_name}"
}

output "vpc_id" {
  value = module.infra.vpc_id
}
