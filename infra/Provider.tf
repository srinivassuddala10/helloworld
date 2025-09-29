terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  access_key = "AKIA6FKNAMGV4S7E3O7I"
  secret_key = "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"
}
