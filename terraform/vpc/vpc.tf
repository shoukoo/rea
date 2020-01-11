resource "aws_vpc" "main" {
  cidr_block = "172.25.0.0/16"
  tags = {
    Name      = "prod_vpc"
    terraform = local.terraform
  }
}

resource "aws_internet_gateway" "main" {
  tags = {
    Name      = "prod_ig"
    terraform = local.terraform
  }
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  tags = {
    Name      = "prod_public_table"
    terraform = local.terraform
  }
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.public.id
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("../../rea.pub")
}
