
## VPC--------------------------------------------------------------------------

output "vpc_id" {
  description = "vpc id of vpc"
  value       = module.exadata_vpc.vpc_id
}

output "private_subnets" {
  description = "List private subnets of vpc"
  value       = module.exadata_vpc.private_subnets
}


output "private_route_tables" {
  description = "List private route tables of private subnets"
  value       = module.exadata_vpc.private_route_table_ids
}


output "ec2_id_1a" {
  description = "ID EC2 of instance in az"
  value       = module.ec2_instance_1.id
}
## ALB----------------------------------------------------------------------

