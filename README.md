# devops-configuration

This repository contains files and deployment configuration for my DevOps course in university and should not be used as a reference.

## Prerequisites

The following tools are required to use this setup:
 - [Task](https://taskfile.dev) (Not necessarily required but makes usage easier)
 - aws cli
 - terraform
 - ansible
 - vagrant (Only required for testing the ansible setup locally)

Aws needs to be authenticated, and several environment variables will have to be set. Check 'Environment' under [Variables](#variables).

## Usage

For easier use all tools should be run through the Taskfile. ([Installation](https://taskfile.dev/#/installation)).

All commands should be run inside the deployment folder.
To perform a full deployment of the app run the following command: `task terraform:up ansible`.  
Run `task terraform:down` to destroy the infrastructure.

To get a full list of all commands run `task --list`.

## Variables

This is an overview of all variables that are available in different tools.
Some variables are passed to Terraform and Ansible through the environment and others are configured in tfvars files.
Terraform can pass variables to ansible through the generated inventory and variables files.


|              Environment |   Terraform    | Ansible                      |
| -----------------------: | :------------: | ---------------------------- |
| CERTIFICATE_ACCESS_TOKEN |       +        | +                            |
|               JWT_SECRET |       +        | +                            |
|           APP_DEPLOY_KEY |       +        | +                            |
|          DNS_CONTROL_KEY |       +        | +                            |
|         TF_HTTP_PASSWORD |       +        |                              |
|          TF_HTTP_ADDRESS |       +        |                              |
|     TF_HTTP_LOCK_ADDRESS |       +        |                              |
|   TF_HTTP_UNLOCK_ADDRESS |       +        |                              |
|                          |   public_key   | ansible_ssh_private_key_file |
|                          |   public_url   | public_url                   |
|                          |    api_url     | api_url                      |
|                          | nodejs_version | nodejs_version               |
|                          |  environment   | deploy_env                   |
|                          | database_port  | app_database_port            |
|                          |  server_port   | app_server_port              |
|                          |  client_port   | app_client_port              |
|                          |                | app_database_vpc_ip_address  |
|                          |                | app_database_ip_address      |
|                          |                | app_database_port            |
|                          |                | app_server_ip_addresses      |
|                          |                | app_server_vpc_ip_addresses  |
|                          |                | app_server_port              |
|                          |                | app_client_ip_addresses      |
|                          |                | app_client_vpc_ip_addresses  |
|                          |                | app_client_port              |
|                          |                | balancer_server_ip_address   |
|                          |                | ansible_host                 |
|                          |                | ansible_user                 |
|                          |                | nodejs_version               |
|                          |                | public_url                   |
|                          |                | api_url                      |
|                          |                |                              |
|                          |                |                              |

