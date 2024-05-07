locals {
  name_sg     = "osb_test_ec2_sg"
  ec2_name_1  = "osb_test_ec2"
  kms_ebs_id  = var.kms_ebs
  #name1_sg    = ""
  #ec2_name_2  = ""
  #kms_ebs_id1 = var.kms_ebs
}

module "ec2_instance_1" {

  providers = {
    aws = aws.osb
  }

  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-ec2-instance-module?ref=v3.3.0"
  #version = "~> 3.0"

  name = local.ec2_name_1

  ami                    = var.ami_master
  instance_type          = var.ec2_1_instance_type
  key_name               = var.ec2_kp
  monitoring             = true
  private_ip             = var.private_ip
  iam_instance_profile   = aws_iam_instance_profile.profile_ec2.name
  vpc_security_group_ids = [module.security_group_ec2.security_group_id]
  subnet_id              = element(module.osb_vpc.database_subnets, 0)
  enable_volume_tags     = false
  root_block_device = [
    {
      device_name           = "/dev/sda1"
      volume_size           = "100"
      volume_type           = "gp3"
      delete_on_termination = true
      tags = merge(var.tags,
        {
          "ib:resource:name" = local.ec2_name_1
        },
        {
          "Name" = local.ec2_name_1
        }
      )
    }

  ]
  tags = merge(var.tags,
    {
      "ib:resource:name" = local.ec2_name_1
    },
    {
      "Name"                     = local.ec2_name_1
      "map-migrated"             = ""
      "ib:resource:patch-policy" = "patch-excepted"
    }
  )
}
resource "aws_ebs_volume" "vol-b" {
  provider          = aws.osb
  availability_zone = ""
  size              = 1024
  iops              = 4000
  throughput        = 125
  type              = "gp3"
  encrypted         = true
  #kms_key_id        = var.kms_ebs
  tags = merge(var.tags, var.compute-tags-ec2_1,
    {
      "ib:resource:name" = local.ec2_name_1
    },
    {
      "Name"         = local.ec2_name_1
      "map-migrated" = ""
  })
}
resource "aws_iam_role" "role_profile_ec2" {
  provider = aws.osb
  name     = "basic-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = merge(var.tags, var.compute-tags,
    {
      "ib:resource:name" = "basic-ec2-role"
    },
    {
      "Name" = "basic-ec2-role"
    }
  )
}
#Attach policy
resource "aws_iam_role_policy_attachment" "role_policy_attachment_profile_ec2" {
  for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ])
  provider   = aws.osb
  policy_arn = each.value
  role       = aws_iam_role.role_profile_ec2.name
}
#Add Instance Profile
resource "aws_iam_instance_profile" "profile_ec2" {
  provider = aws.osb
  name     = "basic-ec2-role"
  role     = aws_iam_role.role_profile_ec2.name
}

/*
resource "aws_volume_attachment" "vol-b" {
  provider    = aws.osb
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.vol-b.id
  instance_id = module.ec2_instance_1.id
}

resource "aws_ebs_volume" "vol-c" {
  provider          = aws.osb
  availability_zone = ""
  size              = 1024
  iops              = 4000
  throughput        = 125
  type              = "gp3"
  encrypted         = true
  kms_key_id        = var.kms_ebs
  tags = merge(var.tags, var.compute-tags-ec2_1,
    {
      "ib:resource:name" = local.ec2_name_1
    },
    {
      "Name"         = local.ec2_name_1
      "map-migrated" = ""
  })
}
resource "aws_volume_attachment" "vol-c" {
  provider    = aws.osb
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.vol-c.id
  instance_id = module.ec2_instance_1.id
}

module "security_group_ec2" {

  providers = {
    aws = aws.osb
  }

  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-security-group-module?ref=v4.7.0"

  name        = local.name_sg
  description = "Security group for usage with EC2 instance"
  vpc_id      = module.osb_vpc.vpc_id

  ingress_cidr_blocks = [""]
  ingress_rules       = ["ssh-tcp"]

  egress_rules = ["all-all"]

  tags = merge(var.tags, var.compute-tags,
    {
      "ib:resource:name" = local.name_sg
    },
    {
      "Name" = local.name_sg
    }
  )
}
module "ec2_instance_2" {

  providers = {
    aws = aws.osb
  }

  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-ec2-instance-module?ref=v3.3.0"
  #version = "~> 3.0"

  name = local.ec2_name_2

  ami                    = var.ami_master
  instance_type          = var.ec2_2_instance_type
  key_name               = var.ec2_kp
  monitoring             = true
  private_ip             = ""
  iam_instance_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  vpc_security_group_ids = [module.security_group_ec2_second.security_group_id]
  subnet_id              = element(module.osb_vpc.database_subnets, 1)
  enable_volume_tags     = false
  root_block_device = [
    {
      device_name           = "/dev/sda1"
      volume_size           = "100"
      volume_type           = "gp3"
      delete_on_termination = true
      tags = merge(var.tags, var.compute-tags,
        {
          "ib:resource:name" = local.ec2_name_2
        },
        {
          "Name" = local.ec2_name_2
      })
    }

  ]
  tags = merge(var.tags, var.compute-tags,
    {
      "ib:resource:name"        = local.ec2_name_2
      "Name"                    = local.ec2_name_2
      "ib:resource:type:backup" = "ec2"
      "ib:resource:monitoring"  = "true"

    }
  )
}
ebs_block_device = [
    {
      device_name = "/dev/sdb"
      volume_type = "gp3"
      volume_size = 1024
      throughput  = 125
      encrypted   = true
      kms_key_id  = local.kms_ebs_id1
    },

resource "aws_volume_attachment" "sdb" {
  provider    = aws.osb
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.sdb.id
  instance_id = module.ec2_instance_2.id
}

resource "aws_ebs_volume" "sdb" {
  provider          = aws.osb
  availability_zone = ""
  size              = 1024
  type              = "gp3"
  encrypted         = true
  kms_key_id        = local.kms_ebs_id1
  tags = merge(var.tags, var.compute-tags,
    {
      "ib:resource:name" = local.ec2_name_2
    },
    {
      "Name" = local.ec2_name_2
    }
  )
}
*/
