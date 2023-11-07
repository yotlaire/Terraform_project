# Highly Available Web App Infrastructure

This project deploys a highly available web application infrastructure on AWS using Terraform. 

## Architecture

The core components of the architecture include:

- **VPC** - A VPC with two public and two private subnets spread across two Availability Zones.

- **Bastion Host** - A bastion host instance in the public subnet to allow inbound SSH access to private instances. 

- **NAT Gateways** - One NAT Gateway in each public subnet to provide outbound internet connectivity to private instances.

- **Application Load Balancer** - A load balancer spanning the public subnets to distribute traffic across instances.

- **Auto Scaling Groups** - Blue/Green ASGs in private subnets based on launch templates and scaling policies.

- **Launch Templates** - Templates that define the AMI, instance type, subnets, and security groups for ASG instances.

- **Route 53** - DNS A records pointing to the ALB for blue/green domains.

- **CloudWatch** - Metrics and alarms for auto scaling of ASGs.

The architecture provides high availability across AZs and allows for blue/green deployments using the ASGs.

## Usage

### Prerequisites

- AWS account
- AWS CLI credentials configured
- Terraform v0.12+ 

### Deployment

1. `terraform init` to initialize Terraform 
2. `terraform plan` to preview infrastructure changes
3. `terraform apply` to deploy the infrastructure
4. Update DNS records to point to new ALB endpoint

### Clean Up

`terraform destroy` terminates all resources deployed.

## Testing

The web application can be tested by accessing the Route 53 domains for blue and green environments. Based on the active ASG, the domain will route traffic to the associated instances.

Load testing tools like Locust can be used to generate traffic for auto scaling testing.

## Improvements

- Convert configuration to Terraform modules
- Implement CI/CD pipeline with Atlantis for gitops 
- Add integration testing using Terratest
- Support zero-downtime deployments with ASG lifecycle hooks

## License

This project is licensed under the MIT License.