terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

/*
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
  alias = branch1
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
  alias = branch2
}
*/