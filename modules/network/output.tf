output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "Returns VPC ID"
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "az" {
  value = data.aws_availability_zones.available
}
