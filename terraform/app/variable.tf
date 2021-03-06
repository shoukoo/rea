locals {
  terraform = "gitlab.com/shoukoo/rea/terraform/${basename(path.cwd)}"
}

provider "aws" {
  region  = "ap-southeast-2"
  profile = "production"
}

data "aws_vpc" "main" {
  cidr_block = "172.25.0.0/16"
}
