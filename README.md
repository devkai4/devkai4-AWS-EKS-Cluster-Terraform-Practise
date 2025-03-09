# AWS EKS Cluster Infrastructure Deployment

This project deploys an EKS cluster and its associated infrastructure on AWS using Terraform.

## Architecture Overview
![AWS EKS Architecture](./images/AWS-EKS-Cluster-Terraform-Practise.drawio.png)
*Figure 1: AWS EKS Architecture with VPC, subnets, security groups and node groups*

The deployed infrastructure includes the following components:

1. **VPC Infrastructure**:
   - Multi-AZ VPC (2 availability zones)
   - Public subnets (2) and private subnets (2)
   - NAT Gateway (for outbound communication from private subnets)
   - Internet Gateway
   - Associated route tables

2. **Bastion Host**:
   - EC2 instance in a public subnet
   - Elastic IP
   - Appropriate security groups
   - SSH key pair for access

3. **EKS Cluster**:
   - EKS control plane
   - IAM role for the cluster
   - API server endpoint configuration

4. **EKS Node Groups**:
   - Node group in public subnets
   - Node group in private subnets
   - IAM role for node groups

## Prerequisites

- Terraform version 1.6.0 or higher installed
- AWS CLI configured with appropriate credentials
- SSH key pair `eks-terraform-key.pem` present in the `private-key` directory

## Deployment Instructions

1. **Initialize the project**:
   ```bash
   terraform init
   ```

2. **Review the deployment plan**:
   ```bash
   terraform plan
   ```

3. **Deploy the infrastructure**:
   ```bash
   terraform apply
   ```

4. **Remove the infrastructure**:
   ```bash
   terraform destroy
   ```

## Configuration Settings

The current configuration uses the following values:

- AWS Region: `us-east-1`
- Environment: `stag`
- Business Division: `hr`
- EKS Cluster Name: `eksdemo1`
- EKS Version: `1.28`
- VPC CIDR: `10.0.0.0/16`
- EC2 Instance Type: `t3.micro` (for Bastion host)

These values can be modified by editing the corresponding `.auto.tfvars` files.

## Security Considerations

- By default, the EKS cluster API endpoint is publicly accessible, but for production environments, it is strongly recommended to restrict `cluster_endpoint_public_access_cidrs` to specific IP address ranges.
- SSH keys should be managed securely, and the `private-key` directory should be added to the `.gitignore` file to prevent accidental commits to the Git repository.

## Accessing the EKS Cluster

After deployment is complete, you can access the EKS cluster with the following steps:

1. Connect to the Bastion host:
   ```bash
   ssh -i private-key/eks-terraform-key.pem ec2-user@<bastion-public-ip>
   ```

2. Retrieve cluster credentials and configure `kubectl`:
   ```bash
   aws eks --region us-east-1 update-kubeconfig --name eksdemo1
   ```

3. Verify cluster status:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

## Troubleshooting

- **Insufficient IAM permissions**: If EKS cluster creation fails, ensure necessary IAM permissions are granted.
- **VPC subnet tags**: Verify that required Kubernetes tags are set on subnets for EKS to function correctly.
- **Connection issues**: If you cannot connect from the Bastion host, check security group rules and SSH key permissions.
- **Node group failures**: If node group deployment fails, check instance type availability and service quotas.
