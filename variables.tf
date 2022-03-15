/*
variable "vpc_id" {
  description = "VPC ID"  
}
*/

variable "public_subnets" {
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

variable "DBStorage" {
  description = "Database storage size"
  default     = 10
}

variable "DBdeletionPolicy" {
  description = "Specifies whether to reatin,delete, or create a snapshot of the DB when terminated"
  default     = "Delete"
}

variable "DBPassword" {
  description = "Database Password"
  default = "Password321"
}

variable "DBUser" { 
  description = "Database Username"
  default = "dbuser"
}

variable "DBInstance_Type" {
  description = "Database RDS Instance Type"
  default = "db.t2.micro"
}

variable "lbLogBucket" {
  description = "S3 Bucket for Load Balancer logs"
}

variable "SSLPolicy" {
  description = "SSL Policy for the Application Load Balancer port 443"
}

#variable "SSLCert" {
#  description = "SSL Certificate for the Load balancer port 443"
#}

variable "dbname" {
 description = "Database Instance Name"
 default = "servicebroker"
}

variable "environment" {
  description = "Service Broker environment"
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

variable "vpc_name" {

}

/*
variable "subnet_public_1" {
   
}

variable "subnet_public_2" {
  
}

variable "subnet_private_1"{
  
}

variable "subnet_private_2" {

}

variable "subnet_rds_1" {

}

variable "subnet_rds_2" {
 
}
*/
