
output "server-ip" {
  description = "Server IP Address"
  value       = aws_instance.app_server.public_ip
}

output "database-ip" {
  description = "Database IP Address"
  value       = aws_instance.app_database.public_ip
}

output "database-vpc-ip" {
  description = "Database VPC IP Address"
  value       = aws_instance.app_database.private_ip
}

output "client-ip" {
  description = "Client IP Address"
  value       = aws_instance.app_client.public_ip
}

output "balancer-server-ip" {
  description = "Balancer Server IP Address"
  value       = aws_instance.balancer_server.public_ip
}

output "username" {
  description = "Server Username"
  value       = var.username
}
