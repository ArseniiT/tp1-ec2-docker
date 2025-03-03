# TP1: EC2 with Docker and SSH in AWS Academy

This project creates an AWS EC2 `t2.micro` instance with Docker installed and SSH access using Terraform in the AWS Academy environment.

## Requirements
- Terraform installed on WSL2 Ubuntu 24.04
- AWS CLI configured with AWS Academy credentials
- SSH key (`~/.ssh/id_rsa.pub`)

## Setup
1. Clone the repository.
2. Configure AWS CLI for AWS Academy:
   ```bash
   nano ~/.aws/credentials

3. Add the credentials
```
[academy]
aws_access_key_id = <YOUR_ACCESS_KEY>
aws_secret_access_key = <YOUR_SECRET_KEY>
aws_session_token = <YOUR_TOKEN>
```
4. Configure AWS CLI for AWS Academy:
   ```bash
   nano ~/.aws/config

3. Add the credentials
```
[profile academy]
region = us-east-1
```

## Deployment
1. Initialize Terraform:
```
terraform init
```
2. Review the plan:
```
terraform plan
```
3. Create the instance:
```
terraform apply
```

## Connecting
- After deployment, note the public IP from the output.
- Connect via SSH:
```
ssh ubuntu@<PUBLIC_IP>
```