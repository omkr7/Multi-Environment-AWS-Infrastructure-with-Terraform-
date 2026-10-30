aws_region           = "ap-south-1"
vpc_cidr              = "10.20.0.0/16"
public_subnet_cidrs   = ["10.20.1.0/24", "10.20.2.0/24"]
private_subnet_cidrs  = ["10.20.11.0/24", "10.20.12.0/24"]
instance_type         = "t3.small"
desired_capacity      = 2
min_size              = 2
max_size              = 5
