# aws-ec2-terraform
Deploy EC2 instance with Terraform

## Setup for macOS

Make sure you do this setup first:

1. [Setup macOS for AWS Cloud DevOps](https://blog.swiftsoftwaregroup.com/setup-macos-for-aws-cloud-devops)

2. [AWS Authentication](https://blog.swiftsoftwaregroup.com/aws-authentication)

3. Install Terraform via Homebrew:

   ```bash
   # install
   brew tap hashicorp/tap
   brew install hashicorp/tap/terraform
   
   # verify
   terraform -help
   ```

## Development

Configure the project:

```bash
source configure.sh
```

Format configuration:

```bash
terraform fmt
```

Validate configuration:

```bash
terraform validate
```

Preview infrastructure:

```bash
terraform plan -out terraform.plan
```

Create infrastructure:

```bash
terraform apply terraform.plan
```

Check state:

```bash
terraform show
```

Connect to instance via SSH:

```bash
key="aws-ec2-key"
instance_public_ip=$(terraform output -json | jq -r '.instance_public_ip.value')
ssh -i ~/.ssh/$key ec2-user@$instance_public_ip
```

## Cleanup

Review the changes and verify the execution plan:

```bash
terraform plan -destroy
```

Delete the resources:

```bash
terraform destroy
```

## How to create a new project

```bash
# create main.tf
cat << 'EOF' > main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# AWS config
# leave empty to read the settings from the AWS CLI configuration
provider "aws" {}
EOF

# initialize the project
# this will download provider plugin into .terraform subdir
terraform init
```

