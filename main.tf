#--------------------------------------------------------------#
#Create instance EC2 and security group, install security group#
#--------------------------------------------------------------#


 provider "aws" {

  region = "us-east-2"

 }

 resource "aws_instance" "webserver" {
    ami = "ami-0d8d212151031f51c"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.webserver.id]  #create dependence
    user_data = file("Install.sh")
    key_name                 =   "aws_key_ohio"

                                                                                          #bootstraping(automatically starting command)
 }

resource "aws_security_group" "webserver" {
  name        = "webserver security group"
  description = "Security group"

  ingress {
                                                                                          #in (server)
    from_port   = 80
                                                                                          #if create new rule, just add same ingress with new param, same to engress
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
   from_port = 22
   to_port = 22
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
   from_port = 443
   to_port = 443
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
                                                                                          #out (server)
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tcp"
  }
  }

  module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "172.31.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets  = ["172.31.16.0/20", "172.31.32.0/20", "172.31.0.0/20"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
output "instance_ips" {                                 # Instance "Webserver" - Public IP
  value = aws_instance.webserver.*.public_dns
}











