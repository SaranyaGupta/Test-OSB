module "osb_vpc" {

  providers = {
    aws = aws.osb
  }
  source               = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-vpc-module?ref=v5.1.2"
  name                 = var.name_vpc
  cidr                 = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  azs              = var.vpc_azs
  private_subnets  = var.vpc_private_subnets

  manage_default_security_group  = false
  default_security_group_ingress = [{}]
  default_security_group_egress  = [{}]

  enable_flow_log                                 = true
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  create_flow_log_cloudwatch_iam_role             = true
  create_flow_log_cloudwatch_log_group            = true
  flow_log_file_format                            = var.flow_log_file_format
  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval
  flow_log_per_hour_partition                     = true
  flow_log_log_format                             = var.flow_log_log_format

  vpc_flow_log_tags = merge(var.tags,
    {
      "ib:resource:name" = var.name_vpc
    },
    {
      "Name" = format("%s-%s", var.name_vpc, "flow-logs")
    }
  )

  tags = merge(var.tags,
    {
      "ib:resource:name" = var.name_vpc
    }
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-Cluster" {
  provider           = aws.osb
  subnet_ids         = [element(module.osb_vpc.private_subnets, 0), element(module.osb_vpc.private_subnets, 1)]
  transit_gateway_id = var.iberia_tgw_id
  vpc_id             = module.osb_vpc.vpc_id
}

## Example routes for route tables to all subnets
resource "aws_route" "route-subnet-0" {
  depends_on = [
    module.osb_vpc.private_subnets,
  ]
  provider               = aws.osb
  for_each               = toset(module.osb_vpc.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.iberia_tgw_id
}

resource "aws_security_group" "allow_tls" {
  provider    = aws.osb
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.osb_vpc.vpc_id
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, var.compute-tags, {
    Name = "${var.name_vpc}_endpoint-security_group"
    }
  )
}
