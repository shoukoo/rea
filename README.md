# REA 

## Requirements
 - macOS
 - terraform version > 0.12
 - AWS account
 - export AWS_SECRET_ACCESS_KEY env variable
 - export AWS_ACCESS_KEY_ID env variable

## Installation 
There are few requirements need to be fulfilled before running the script.
 - You must use Terraform version 0.12 or later 
 - You can provide your credentials via the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables.
 
### Deployment
Once you have fulfilled all the requirements above then you can run the script below to deploy the application.

```bash
# This command line will build the infra 
make apply

```

At the end of the script, you should see a message to show you how to access the application
```bash
# The message looks like this
Open http://xx.xx.xx.xx in your browser to access the app
```
### Design
I am trying to make the deployment as automated as possible without relying on much human interaction. The `make apply` target takes care of the entire deployment process by
- Verifying all the requirements are fullfilled ( AWS key and Terraform )
- Generating ssh keypair
- Applying infrastructure on AWS through Terraform
- Monitoring the process of deployment and prints log to the standard output

## Shortcoming of this design
- It's not highly available, only lives on one availability zone.
- Monolith design only can scale vertically. I would add an ELB and auto-scaling group to mitigate the issue
- Port 22 is exposed to the internet, I would implement a VPN to strengthen the security.
- It's not running on HTTPS
