variable name {
  default = "app"
}
resource "aws_security_group" "main" {
  tags = {
    Name      = var.name
    terraform = local.terraform
  }
  name        = var.name
  description = "listen to port 80"
  vpc_id      = data.aws_vpc.main.id
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "main" {
  count             = "1"
  vpc_id            = data.aws_vpc.main.id
  cidr_block        = "172.25.30.0/25"
  availability_zone = "ap-southeast-2b"
  tags = {
    Name      = "app_subnet"
    terraform = local.terraform
  }
}

resource "aws_iam_role" "main" {
  name = var.name

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": ["ec2.amazonaws.com"]
             },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

}

resource "aws_iam_instance_profile" "main" {
  name = var.name
  role = aws_iam_role.main.id
}

resource "aws_iam_role_policy" "tagging" {
  name = "describe_instance_tags"
  role = aws_iam_role.main.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action":[
        "ec2:DescribeTags",
        "ec2:DescribeInstances",
        "ec2:DescribeImages"
      ],
      "Effect": "Allow",
      "Resource":"*"
    }
  ]
}
EOF
}

resource "aws_instance" "main" {
  tags = {
    Name      = var.name
    terraform = local.terraform
  }

  volume_tags = {
    Name      = var.name
    terraform = local.terraform
  }

  count                       = 1
  associate_public_ip_address = true
  ami                         = "ami-07cc15c3ba6f8e287"
  subnet_id                   = aws_subnet.main[0].id

  vpc_security_group_ids = [
    aws_security_group.main.id,
  ]

  instance_type        = "t2.nano"
  key_name             = "deployer-key"
  iam_instance_profile = aws_iam_instance_profile.main.id

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      ami,
      user_data,
      instance_type,
    ]
  }

  user_data = file("./user_data.sh")

  provisioner "local-exec" {
    command = "./wait_for_user_data.sh ${self.public_ip}"
  }
}
