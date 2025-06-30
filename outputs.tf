# ------------------------------------------------------------------
# outputs.tf
#
# This file defines the output values from the resources created.
# ------------------------------------------------------------------

output "public_ip" {
  description = "The public IP address of the EC2 web server."
  value       = aws_instance.web_server.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.web_server.id
}
