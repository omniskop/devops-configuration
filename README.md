# devops-configuration

This repository contains files and deployment configuration for my DevOps course in university and should not be used as a reference.

- [devops-configuration](#devops-configuration)
  - [Concept](#concept)
  - [Deployment](#deployment)
    - [Prerequisites](#prerequisites)
    - [Usage](#usage)
    - [Variables](#variables)
    - [The Process](#the-process)
  - [Monitoring](#monitoring)
    - [Balancer](#balancer)
    - [Database](#database)
    - [Server](#server)
    - [Client](#client)

## Concept

The original concept can be read [here](Concept.md) but it it not up to date.

## Deployment

### Prerequisites

The following tools are required to use this setup:
 - [Task](https://taskfile.dev) (Not necessarily required but makes usage easier)
 - aws cli
 - terraform
 - ansible
 - vagrant (Only required for testing the ansible setup locally)

Aws needs to be authenticated, and several environment variables will have to be set. Check 'Environment' under [Variables](#variables).

### Usage

For easier use all tools should be run through the Taskfile. ([Installation](https://taskfile.dev/#/installation)).

All commands should be run inside the deployment folder.
To perform a full staging deployment of the app run the following command: `task all`. For a production deployment set the environment variable "env" to "prodocution".  
Run `task terraform:down` to destroy the infrastructure.

To get a full list of all commands run `task --list`.

The ansible/vagrant folder contains a vagrant setup that was used for local testing without needing to use terraform but it is currently not functioning.

### Variables

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
|   PROMTAIL_LOKI_PASSWORD |       +        | +                            |
|      PROMETHEUS_PASSWORD |       +        | +                            |
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

### The Process

The following describes a full deployment executed through GitHub Actions:

 - Requirements are being installed
 - Private and public key are copied from a secret to a local file that can be accessed by terraform and ansible.
 - AWS credentials are fetched through a POST request from an external server. The access is authorized by the `AWS_CREDENTIALS_KEY` secret.
 - Terraform will be initialized.
 - The Terraform state is modified and moves existing server and client instances to an "outdated" state.  
   The states for staging and production are stored is a custom http backend that is hosted on an external server and is authenticated using the `TF_HTTP_PASSWORD` secret.
 - Terraform is run and it will create new server and client instances while keeping the old ones.  
   Terraform generates two files for ansible: An inventory file and a file containing variables with various additional information that ansible will need.
 - A small delay has been added here because GitHub Actions sometimes executed ansible to quickly after terraform when instances weren't available yet.
 - Ansible will now provision the new instances and updates the load balancer to the new internal ip addresses.  
   It can setup four different types of instances:
   - Database
     - A simple mongodb installation
   - Server
     - Clones the correct branch of the app and runs it using [pm2](https://pm2.keymetrics.io)
   - Client
     - Clones the correct branch of the app, builds the client and hosts it using nginx.
   - Balancer
     - Contains a prometheus server that bundles all metrics from the other instances.
     - Runs nginx as a load balancer for server and client.
     - Also a reverse proxy for prometheus, adding ssl encryption and authentication.
     - The ssl certificate is downloaded from an external server using the key in the `CERTIFICATE_ACCESS_TOKEN` secret. The certificate is internally provided by letsencrypt and valid for todo.omniskop.de and *.todo.omniskop.de.
     - The dns entry for the correct domain is updated through an external server using the key in the `DNS_CONTROL_KEY` secret. The server then updates the dns settings of a personal INWX account.
 - Terraform is executed again to now destroy the outdated instances.

This diagram shows the major components of the deployed application and their interaction.
![aasd](infrastructure_diagram.png)

## Monitoring

All monitoring is available through an externally installed grafana instance. The instances are using different means to report their different metrics.
The instances all share reporting of /var/log/syslog and /var/log/auth.log files.

### Balancer

The balancer is running a prometheus instance that scrapes metrics from all other services and provides a centralized access to them.
It is proxied through nginx which adds basic authentication with username "prometheus" and the password set through PROMETHEUS_PASSWORD.
Metrics for production are available at `todo.omniskop.de:9091` and for staging at `staging.todo.omniskop.de:9091`.

### Database

Mongodb logs are collected using promtail and proactively sent to loki running on an external server next to grafana.
Basic Auth is used for authentication with username "loki" and the password specified in `PROMTAIL_LOKI_PASSWORD`.

### Server

PM2-metrics is used to collect various information about the running server. It is only available inside the vpc network and can be accessed through prometheus running on the balancer.
Promtail will collect stdout and stderr logs separately.

### Client

Nginx access and error logs are collected using promtail and proactively sent to loki running next to grafana.
Basic nginx statistics are collected using nginx-prometheus-exporter.
