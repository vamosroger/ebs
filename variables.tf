variable "elb_subnets" {
  description = "List public subnet id"
  type = list
}

variable "private_subnets" {
  description = "List private subnet id"
  type = list
}

variable "database_subnets" {
  description = "List database subnet id"
  type = list
}

variable "elasticappname" {
  description = "Name of the application"
}

variable "beanstalkappenv" {
  description = "Name of the Elastic Beanstalk Environment"
}

variable "solution_stack_name" {
  description = "Solution Stack name for the environment"
  default = "64bit Amazon Linux 2 v2.2.10 running .NET Core"
} 

variable "instance_type" {
  description = "EC2 Instance Type"
  default = "t2.micro"
}


variable "lbLogBucket" {
  description = "S3 Bucket for Load Balancer logs"
}

variable "SSLPolicy" {
  description = "SSL Policy for the Application Load Balancer port 443"
}

variable "environment" {
  description = "Elastic Beanstalk environment"
}

variable "secrets_arn" {
 description = "ARN of Secret in Secrets Manager"
}

variable "appname" {
 description = "Application Tag name"
}

variable "certdomain"{
 description = "domain for the certificate"
 type = string

}

variable "ELBScheme" {
 description = "Specify the ELB Scheme if internal or internet facing, valid values are public or internal"
 default = "public"
}

variable "vpc_name" {
 description = "The tag:name value of the VPC"
 type = string
}

variable "ec2_role"{
 description = "elastic beanstalk ec2 role"
 default = "aws-elasticbeanstalk-ec2-role"
}

variable "ebs_role" {
 description = "elastic beanstalk iam role"
 default = "aws-elasticbeanstalk-service-role"
}


variable "rolling_update" {
  description = "Rolling Update Policy Setting, valid input Time,Health,Immutable"
  default = "Health"
}

variable "deployment_policy" {
  description = "Deployment Policy Setting, valid input AllAtOnce,Rolling,RollingWithAdditionalBatch,Immutable,TrafficSplitting"
  default = "Rolling"
}

variable "min_instance" {
  description = "Minimum EC2 Instance in Autoscaling"
  default = 2
}

variable "max_instance" {
 description = "Maximum EC2 Instance in Autoscaling"
 default = 3
}
