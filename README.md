# Multi-Environment AWS Infrastructure with Terraform-   

Reusable Terraform module deploys isolated dev and prod stacks with a VPC, public/private subnets in two AZs, one NAT Gateway, ALB, private EC2 Auto Scaling Group, IAM instance role and security groups.

## Prerequisites
- Terraform >= 1.5
- AWS CLI configured (`aws configure`) with permissions to create VPC, EC2, ELB, IAM, S3 and DynamoDB resources.
- An AWS region with at least two available AZs.

## 1. Create remote state resources
Choose a globally unique bucket name and edit `bootstrap/terraform.tfvars` (create this file):
```hcl
aws_region       = "ap-south-1"
state_bucket_name = "your-unique-terraform-state-bucket-name"
lock_table_name   = "terraform-state-locks"
```
Then:
```bash
cd bootstrap
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

## 2. Deploy dev
Replace `YOUR_STATE_BUCKET` below with the bucket created above:
```bash
cd ../environments/dev
terraform init -backend-config="bucket=YOUR_STATE_BUCKET" -backend-config="key=dev/terraform.tfstate" -backend-config="region=ap-south-1" -backend-config="dynamodb_table=terraform-state-locks" -backend-config="encrypt=true"
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform output
```

## 3. Deploy prod
```bash
cd ../prod
terraform init -backend-config="bucket=YOUR_STATE_BUCKET" -backend-config="key=prod/terraform.tfstate" -backend-config="region=ap-south-1" -backend-config="dynamodb_table=terraform-state-locks" -backend-config="encrypt=true"
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform output
```

Each environment has a different state key and CIDR range. The same module is reused with different sizing and configuration.

## 4. Test self-healing
1. Open the `application_url` output in a browser.
2. In the EC2 console, find an instance belonging to the environment's Auto Scaling Group.
3. Terminate that instance (test in dev first).
4. Check the ASG Activity tab and confirm a replacement instance launches and registers healthy with the target group.

## 5. Cleanup
Destroy prod and dev separately, then remove the backend resources only after both state files are no longer needed:
```bash
cd environments/prod && terraform destroy
cd ../dev && terraform destroy
cd ../../bootstrap && terraform destroy
```

## Notes
- A NAT Gateway incurs ongoing hourly and data-processing charges. This example uses one NAT Gateway per environment to reduce cost; it is not fully AZ-resilient. Production designs commonly use one NAT Gateway per AZ.
- The ALB is internet-facing and serves HTTP for demonstration. Use HTTPS with ACM and a domain for a real deployment.
- DynamoDB-based S3 state locking is supported by the AWS backend but is deprecated in newer Terraform releases in favor of S3 native lockfiles. This project retains DynamoDB locking to match the stated project requirement. Check current Terraform backend documentation before upgrading.
- Do not commit AWS credentials, state files, `.terraform/`, or private keys to GitHub.
writen by AI :)
