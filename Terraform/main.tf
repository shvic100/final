terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "ec2" {
  source = "./ec2"
}

module "autoscale" {
  source = "./autoscale"
}

module "lb" {
  source = "./lb"
}

module "karpenter" {
  source = "./karpenter"
}

module "rds" {
  source = "./rds"
}
