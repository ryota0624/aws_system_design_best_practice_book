# backendとproviderというのはなんだろう。

# backend
terraform {
  backend "local" {}
}

# provider
provider "aws" {
  region = "us-east-1"

  access_key = "mock_access_key"
  secret_key = "mock_secret_key"

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    es             = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    route53        = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"

  }
}

# variable "example_instance_type" {
#   default = "t3.micro"
# }

locals {
  example_instance_type = "t3.micro"
}

resource "aws_security_group" "example_ec2" {
  name = "example-ec2"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_instance" "example" {
  ami = "ami0c3fd0f5d33134a76"
  # ami           = data.aws_ami.recent_amazon_linux_2.image_id
  # instance_type = var.example_instance_type
  instance_type = local.example_instance_type
  tags = {
    Name = "example"
  }
  vpc_security_group_ids = [ aws_security_group.example_ec2.id ]

  user_data = file("./user_data.sh")
}

# localstackでは動作しない(結果が返らない)
# data "aws_ami" "recent_amazon_linux_2" {
#   most_recent = true
#   owners = [ "amazon" ]
#   filter {
#     name = "name"
#     values = ["amazn2-ami-hvm-2.0.???????-x86_64-gp2"]
#   }

#   filter {
#     name = "state"
#     values = [ "available" ]
#   }
# }

output "example_instance_id" {
  value = aws_instance.example.id
}

output "example_public_dns" {
  value = aws_instance.example.public_dns
}
