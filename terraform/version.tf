terraform {
  required_version = ">= 1.5.0"
  backend "remote" {
    organization = "daimones"

    workspaces {
      name = "eks-app"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.55.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 2.2"
    }
  }
}

# Prod Region
provider "aws" {
  region = "us-east-1"
  alias  = "prod"
}
