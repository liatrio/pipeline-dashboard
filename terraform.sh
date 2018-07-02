#!/bin/bash
workspace=$(dirname 0)

# initialize the workspace
#this is necessary for using remote state storage
terraform init -input=false

#create workspace
export TF_WORKSPACE=$TF_VAR_instance_name

#create and switch to a new workspace
terraform workspace new $TF_VAR_instance_name

#create the tfplan
terraform plan -out=tfplan -input=false

# initialize the instance
terraform apply -input=false tfplan

exit $EXIT_STATUS
