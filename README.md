# xlb

## Requirements and Assumptions

Packer & Terraform installed  
AWS credentials stored in ~/.aws/credentials in the following format

    [default]
    aws_access_key_id=AKIAIOSFODNN7EXAMPLE
    aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

The user executing Packer build will be provisioned within the generated ami.  
Also, it assumes the user has an existing public key in ~/.ssh/id_rsa.pub




## Packer usage
Use packer directory as working directory. Takes 5-6 minutes to build in parallel.

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
