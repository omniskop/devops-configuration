terraform {
  required_version = ">= 0.14.9"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "http" {
    lock_method = "POST"
    unlock_method = "POST"
    username = "terraform"
    # password, address, lock_address and unlock_address have to be configured through the environment
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# ssh key used for authorization
resource "aws_key_pair" "aws_key" {
  public_key = file(var.public_key)
}

# generate the ansible inventory
resource "local_file" "ansible_inventory" {
  filename = "../tf_inventory.yml"

  content = templatefile("templates/inventory.tmpl", {
    "username": var.username,
    "app_database_ip_address" : aws_instance.app_database.public_ip
    "app_server_ip_addresses" : aws_instance.app_server.*.public_ip
    "app_client_ip_addresses" : aws_instance.app_client.*.public_ip
    "balancer_server_ip_address": aws_instance.balancer_server.public_ip
  })
}

# generate the ansible variables
resource "local_file" "ansible_variables" {
  filename = "../tf_variables.yml"

  content = templatefile("templates/variables.tmpl", {
    "nodejs_version": var.nodejs_version
    "public_url": var.public_url
    "api_url": var.api_url
    "environment": var.environment

    "app_database_ip_address": aws_instance.app_database.public_ip
    "app_database_vpc_ip_address": aws_instance.app_database.private_ip
    "app_database_port": var.database_port

    "app_server_ip_addresses": aws_instance.app_server.*.public_ip
    "app_server_vpc_ip_addresses": aws_instance.app_server.*.private_ip
    "app_server_port": var.server_port

    "app_client_ip_addresses": aws_instance.app_client.*.public_ip
    "app_client_vpc_ip_addresses": aws_instance.app_client.*.private_ip
    "app_client_port": var.client_port

    "balancer_server_ip_address": aws_instance.balancer_server.public_ip
  })
}
