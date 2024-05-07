module "security_group_ec2" {

  providers = {
    aws = aws.osb
  }

  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-security-group-module?ref=v4.7.0"

  name        = var.name_sg_ec2
  description = "Security group for usage with EC2 instance"
  vpc_id      = module.osb_vpc.vpc_id
  ingress_with_source_security_group_id = [

    {
      from_port                = 0
      to_port                  = 65535
      protocol                 = "tcp"
      #source_security_group_id = module.security_group_ec2_xxxxx.security_group_id
    }

  ]
  egress_rules = ["all-all"]

  tags = merge(var.tags, var.compute-tags,
    {
      "ib:resource:name" = local.name_sg_ec2
    },
    {
      "Name" = local.name_sg_ec2
    }
  )
}

resource "aws_security_group_rule" "port_22" {
  provider          = aws.osb
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "ssh"
  cidr_blocks       = [""]
  security_group_id = module.security_group_ec2.security_group_id
}
/*
module "security_group_ec2_second" {

  providers = {
    aws = aws.osb
  }

  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-security-group-module?ref=v4.7.0"

  name         = ""
  description  = "Security group for usage with EC2 instance"
  vpc_id       = module.osb_vpc.vpc_id
  egress_rules = ["all-all"]

  tags = merge(var.tags, var.compute-tags,
    {
      "ib:resource:name" = ""
    },
    {
      "Name" = ""
    }
  )
}

resource "aws_security_group_rule" "second_port_22" {
  provider          = aws.osb
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [""]
  security_group_id = module.security_group_ec2_second.security_group_id
}


module "security_group_alb" {

  providers = {
    aws = aws.osb
  }

  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-security-group-module?ref=v4.7.0"

  name         = local.name_sg_alb
  description  = "Security group for usage with EC2 instance for ALB"
  vpc_id       = module.osb_vpc.vpc_id
  egress_rules = ["all-all"]

  tags = merge(var.tags, var.compute-tags,
    {
      "ib:resource:name" = local.name_sg_alb
    },
    {
      "Name" = local.name_sg_alb
    }
  )
}

### Rules for ALB security group (security_group_alb)
resource "aws_security_group_rule" "http_alb" {
  provider          = aws.osb
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [""]
  security_group_id = module.security_group_alb.security_group_id
}
*/
