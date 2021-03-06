# xlb

## Purpose

Fully provision and demonstrate a cloud based infrastructure in Amazon AWS with the following features:
* Customized AMI operating system images built in automated fashion using Packer
* Completely managed cloud infrastructure using Hashicorp Terraform
* Hashicorp Consul used as a service registry and health check utility
* Hashicorp Consul template installed to integrate with Consul to generate application configuration templates based on service availability and health


## Requirements and Assumptions

Packer & Terraform installed  
An existing Amazon AWS account  
AWS credentials stored in ~/.aws/credentials in the following format:

    [default]
    aws_access_key_id=AKIAIOSFODNN7EXAMPLE
    aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

The user executing Packer build will be provisioned within the generated ami.  
Also, it assumes the user has an existing public key in ~/.ssh/id_rsa.pub




## Packer usage
Use packer directory as working directory. Takes ~5 minutes to build 3 ami's in parallel.

    packer build packer.json




## Terraform usage
Use terraform directory as working directory.  
Copy terraform.tfvars.example to terraform.tfvars and enter your information there.

    # apply terraform modules
    terraform get

    # execute plan to verify changes to be performed
    terraform plan

    # apply changes
    terraform apply

Outputs from successfully `terraform apply` shown below  
_tip: setup iTerm to allow clickable links_
![terraform outputs](/images/outputs.png?raw=true)

Graph generated by `terraform graph | dot -Tpng > graph.png`

![terraform graph](/images/graph.png?raw=true)

## Vault

See Vault.md for further notes related to Vault 
