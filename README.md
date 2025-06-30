Terraform AWS EC2 Web Server
This repository contains a simple Terraform project to provision a basic web server on an AWS EC2 instance. The server will be deployed within a new VPC and will be accessible from the internet.

This project is a practical example of how to structure a basic Terraform setup using main.tf, variables.tf, and outputs.tf.

📂 Project Structure
.
├── main.tf         # Core infrastructure resources (VPC, Subnet, EC2, etc.)
├── variables.tf    # Input variables for customization (e.g., region, instance type)
├── outputs.tf      # Output values after deployment (e.g., server's public IP)
└── README.md       # This file

Prerequisites
Terraform Installed: You need Terraform installed on your local machine.

AWS Account: An active AWS account.

AWS CLI Configured: The AWS CLI must be installed and configured with your credentials. You can do this by running:

aws configure

Or, if using a specific profile:

aws configure --profile your-profile-name

🛠️ Basic Terraform Workflow
Follow these steps to deploy and destroy the infrastructure.

1. Initialize Terraform
Navigate to the project directory in your terminal and run this command. It downloads the necessary provider plugins (in this case, for AWS).

terraform init

2. Plan (Dry Run)
This command creates an execution plan, showing you exactly what resources Terraform will create, modify, or destroy. It's a safe way to review changes before applying them.

terraform plan

3. Apply Infrastructure
This command applies the changes defined in the plan. It will provision the VPC, subnet, security group, and EC2 instance in your AWS account. Terraform will ask for a final yes confirmation before proceeding.

terraform apply

4. Destroy Infrastructure
When you no longer need the resources, run this command to tear everything down. This helps avoid incurring unnecessary costs. Terraform will also ask for a final yes confirmation.

terraform destroy

✅ Accessing Your Web Server
After a successful terraform apply, the public IP address of the EC2 instance will be displayed in the terminal as an output. You can copy this IP address and paste it into your web browser. You should see a "Hello, World" message.