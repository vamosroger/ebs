data "aws_vpc" "vpc" {  
    tags = {
       Name = var.vpc_name
    }
}

data "aws_subnet" "subnet_public" {
  count = 2
  tags = {
      Name = var.elb_subnets[count.index]
   }
}

data "aws_subnet" "subnet_private" {
  count = 2
  tags = {
      Name = var.private_subnets[count.index]
   }
}

data "aws_subnet" "subnet_rds" {
  count = 2
  tags = {
      Name = var.database_subnets[count.index]
   }
}

data "aws_acm_certificate" "issued" {
  domain = var.certdomain
  statuses = ["ISSUED"]
}

data "aws_iam_role" "ebssvcrole" {
  name = var.ebs_role
}

data "aws_secretsmanager_secret" "name" {
  name = var.secrets_name
}
