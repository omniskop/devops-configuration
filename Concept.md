
# Concept for deploying "ToDo App"

## Setup

It should be possible to automatically setup the app on Amazon Web Services  
and ideally Terraform will be used to achieve this.  
The app consists of two separate parts. The database and the server itself.
They should be run separately. 

## Deployment

New releases in the repository should use Github Actions to automatically start  
the deployment process.
This includes the following steps:  
* A) Run all tests to confirm a functioning code base.
* B) Stop, update and start instances.

It is planned to use Ansible for the configuration of the individual instances.  
That should also allow to installed all required dependencies of the app.

## Development

To aid the development process it is helpfull to also have a separate environment  
which allows testing in a production-like environment.  
This process should be easy to setup using the same tools, allowing for a seamless  
transition from development to production.
