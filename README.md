Terraform Setup
Installation
Using Winget on Windows:
Search Terraform
winget search terraform

Install Terraform
winget install "HashiCorp Terraform"

Upgrade Terraform
winget upgrade Hashicorp.Terraform

AWS CLI Configuration
Configure AWS Profile
aws configure --profile demoaws

Basic Terraform Script: VPC and EC2 Instance
Initialize Terraform
terraform init

Plan (Dry Run)
terraform plan

Apply Changes
terraform apply

Destroy Infrastructure
terraform destroy

After a few minutes, Terraform will finish and display the public_ip from the outputs.
You can then open that IP address in your web browser to see the "Hello from Terraform!" message.

✅ Now you can paste this directly into a README or text document without formatting issues. Let me know if you want a sample Terraform .tf code block next!