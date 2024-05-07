terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket         = "osb-pre-state"
    key            = "pre/terraform.tfstate"
    region         = "eu-west-1"
    #region          = "us-east-1"
    dynamodb_table = "pre-osb-terraform-locks"
    encrypt        = true
    assume_role = {
      role_arn = "arn:aws:iam::237106410778:role/RoleGithubRunners_Infrastructure_Pre_common"
    }
  }
}

provider "aws" {
  alias  = "osb"
 region = "eu-west-1"
  #region          = "us-east-1"
  assume_role {
  role_arn = "arn:aws:iam::237106410778:role/RoleGithubRunners_Infrastructure_Pre_common"
  }
}
