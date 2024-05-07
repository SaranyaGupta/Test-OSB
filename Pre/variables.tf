variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
}
variable "compute-tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
}
variable "account_number" {
  description = "Account number"
  type        = string
}
variable "iberia_tgw_id" {
  description = "TGW Iberia"
  type        = string
  default     = "tgw-0db3fdc0f9da71974"
}

variable "vpc_azs" {
  description = "List AZS for Subnets"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
#default     = ["us-east-1a", "us-east-1b"]
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = "Flow vpc Retention Days"
  type        = number
  default     = 14
}

variable "flow_log_max_aggregation_interval" {
  description = "Flow vpc aggregation_interval"
  type        = number
  default     = 60
}

variable "flow_log_file_format" {
  description = "Flow vpc file format"
  type        = string
  default     = "parquet"
}

variable "flow_log_log_format" {
  description = "Flow vpc log format"
  type        = string
  default     = "$${version} $${account-id} $${vpc-id} $${subnet-id} $${instance-id} $${interface-id} $${srcaddr} $${srcport} $${dstaddr} $${dstport} $${protocol} $${tcp-flags} $${type} $${pkt-srcaddr} $${pkt-src-aws-service} $${pkt-dstaddr} $${pkt-dst-aws-service} $${action} $${log-status}"
}

## VPC ACCOUNT------------------------------------------------------------------
variable "name_vpc" {
  description = "Vpc name for account"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "Vpc CIDR for Account"
  type        = string
  default     = ""
}

variable "vpc_private_subnets_cluster" {
  description = "List private subnets for Account"
  type        = list(string)
  default     = []
}
variable "name_sg_ec2" {
  description = "sg for EC2"
  type        = string
  default     = ""
}

variable "ec2_kp" {
  description = "Key to exadata servers to login"
  type        = string
  default     = "exadata_servers_key"
}
/*
variable "ami_master" {
  description = "Id AMI of the master instance jboss"
  type        = string
}
*/
variable "ec2_1_instance_type" {
  type    = string
  default = ""
}
variable "private_ip" {
  type    = string
  default = ""
}

variable "kms_ebs" {
  description = "this is used with aws_ebs_volume resources."
  type        = string
  default     = ""
}
variable "ami_master" {
  type    = string
  default = "ami-095517e563ec82ffc"
}
