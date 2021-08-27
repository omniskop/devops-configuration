
output "database-ip" {
  description = "Database IP Address"
  value       = aws_instance.app_database.public_ip
}

output "database-vpc-ip" {
  description = "Database VPC IP Address"
  value       = aws_instance.app_database.private_ip
}

output "server-ip" {
  description = "Server IP Addresses"
  value       = aws_instance.app_server[0].public_ip
}

output "server-ips" {
  description = "Server IP Addresses"
  value       = aws_instance.app_server.*.public_ip
}

output "client-ip" {
  description = "Client IP Addresses"
  value       = aws_instance.app_client[0].public_ip
}

output "client-ips" {
  description = "Client IP Addresses"
  value       = aws_instance.app_client.*.public_ip
}

output "balancer-server-ip" {
  description = "Balancer Server IP Address"
  value       = aws_instance.balancer_server.public_ip
}

output "username" {
  description = "Server Username"
  value       = var.username
}
