terraform {
  cloud {
    organization = "djay"
    hostname     = "app.terraform.io"

    workspaces {
      tags = ["tf-aws-modules"]
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}