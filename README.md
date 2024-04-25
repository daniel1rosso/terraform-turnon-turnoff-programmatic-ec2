# Terraform-EC2-Automation

## Description:
This repository contains Terraform configurations for automating the provisioning and deprovisioning of EC2 instances programmatically. With these Terraform scripts, you can effortlessly spin up and shut down EC2 instances based on your application's needs, optimizing costs and resource utilization.

## Features:

Programmatic EC2 Management: Utilize Terraform to manage the lifecycle of EC2 instances programmatically, enabling seamless provisioning and deprovisioning.
Turn On/Turn Off: Easily turn on or turn off EC2 instances based on predefined configurations, allowing for efficient resource management.
Cost Optimization: By automating the process of starting and stopping EC2 instances, optimize costs by only running instances when necessary.
Infrastructure as Code (IaC): Leverage Terraform's declarative syntax to define your infrastructure requirements, ensuring consistency and reproducibility.

## Usage:

### 1. Clone the Repository

### 2. Customize Configuration:
Modify the terraform.tfvars and lambda file to specify your instance id, region and other parameters as per your requirements.

### 3. Initialize Terraform:
- terraform init

### 4. Preview Changes:
- terraform plan

### 5. Apply Changes:
- terraform apply

## Requirements:

### 1. Terraform installed locally
### 2. AWS account with appropriate permissions
### 3. Access and Secret keys configured for AWS IAM user

## Contributing:
Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or create a pull request.

## Disclaimer:
Please use this automation responsibly and ensure that you understand the costs associated with running EC2 instances on AWS. The maintainers of this repository are not liable for any unexpected charges incurred as a result of using these Terraform configurations.
