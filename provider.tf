terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
        }
    }
}

#configure aws provider
provider "aws" {
    region = "us-east-2"
}