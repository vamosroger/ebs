# Create Security Group 

resource "aws_security_group" "elb_sg" {
  name = "EBS Load Balancer SG"
  description = "EBS Load Balancer Security Group"
  vpc_id = data.aws_vpc.vpc.id 
}

resource "aws_security_group" "ec2_sg" {
  name = "EBS EC2 SG"
  description = "EBS EC2 Security Group"
  vpc_id = data.aws_vpc.vpc.id 
}

# Security Group Inbound and Outbound Rules

resource "aws_security_group_rule" "elb_inb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb_sg.id	
}

resource "aws_security_group_rule" "elb_oub_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb_sg.id	
}

resource "aws_security_group_rule" "elb_oub_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb_sg.id	
}

resource "aws_security_group_rule" "ec2_inb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = aws_security_group.elb_sg.id
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ec2_oub_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}

#resource "aws_security_group_rule" "ec2_oub_http" {
#  type              = "egress"
#  from_port         = 80
#  to_port           = 80
#  protocol          = "tcp"
#  cidr_blocks       = ["0.0.0.0/0"]
#  security_group_id = aws_security_group.ec2_sg.id
#}

# Create elastic beanstalk application


resource "aws_elastic_beanstalk_application" "elasticapp" {
  name                = var.elasticappname
}

# Create elastic beanstalk Environment

resource "aws_elastic_beanstalk_environment" "beanstalkappenv" {
  name                = var.beanstalkappenv
  application         = aws_elastic_beanstalk_application.elasticapp.name
  solution_stack_name = var.solution_stack_name
  #tier                = var.tier

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = data.aws_vpc.vpc.id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     =  var.ec2_role
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     =  aws_security_group.ec2_sg.id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     =  "False"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",",[data.aws_subnet.subnet_public.*.id[0],data.aws_subnet.subnet_public.*.id[1]])
    #value     = join(",", var.public_subnets)
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",",[data.aws_subnet.subnet_private.*.id[0],data.aws_subnet.subnet_private.*.id[1]])
    #value     = join(",", var.private_subnets)
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "DBSubnets"
    value     = join(",",[data.aws_subnet.subnet_rds.*.id[0],data.aws_subnet.subnet_rds.*.id[1]])
    #value     = join(",", var.database_subnets)
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = var.ELBScheme
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = data.aws_iam_role.ebssvcrole.arn
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.min_instance
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.max_instance
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "ConfigDocument"
    value     = file("${path.module}/metric.json")
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "PreferredStartTime" 
    value     = "Sat:22:00"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "UpdateLevel" 
    value     = "minor"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "HealthStreamingEnabled" 
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy" 
    value     = var.deployment_policy
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType" 
    value     = var.rolling_update
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled" 
    value     = "true"
  }
  #setting {
  #  namespace = "aws:elasticbeanstalk:command"
  #  name      = "DeploymentPolicy" 
  #  value     = "Immutable"
  #}
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "AccessLogsS3Enabled" 
    value     = "true"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "ManagedSecurityGroup" 
    value     = aws_security_group.elb_sg.id
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups" 
    value     = aws_security_group.elb_sg.id
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "AccessLogsS3Bucket" 
    value     = var.lbLogBucket
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns" 
    value     = data.aws_acm_certificate.issued.arn
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLPolicy" 
    value     = var.SSLPolicy
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol" 
    value     = "HTTPS"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AwsSecretsManagerSettings__ARN" 
    value     = var.secrets_arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs" 
    value     = "true"
  }

  tags = {
      Application = var.appname
      Environment = var.environment
  }
}
