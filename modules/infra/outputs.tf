output "vpc_id" {
  value = aws_vpc.this.id
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.this.name
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
