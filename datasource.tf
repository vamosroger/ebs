data "aws_vpc" "vpc" {  
    tags = {
       Name = var.vpc_name
    }
}

/*

data "aws_subnet" "subnet_public_1" {
  tags = {
      Name = var.subnet_public_1
   }
}

data "aws_subnet" "subnet_public_2" {
  tags = {
      Name = var.subnet_public_2
   }
}

data "aws_subnet" "subnet_private_1" {
  tags = {
      Name = var.subnet_private_1
   }
}

data "aws_subnet" "subnet_private_2" {
  tags = {
      Name = var.subnet_private_2
   }
}

data "aws_subnet" "subnet_rds_1" {
  tags = {
      Name = var.subnet_rds_1
   }
}

data "aws_subnet" "subnet_rds_2" {
  tags = {
      Name = var.subnet_rds_2
   }
}
*/

data "aws_subnet" "subnet_public" {
  count = 2
  tags = {
      Name = var.public_subnets[count.index]
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
