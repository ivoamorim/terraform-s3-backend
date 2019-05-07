#!/bin/sh

#export AWS_ACCESS_KEY_ID="anaccesskey"
#export AWS_SECRET_ACCESS_KEY="asecretkey"

terraform workspace new example
terraform workspace select example

terraform init -backend-config=example/backend.tfvars example
terraform apply -var-file=example/backend.tfvars example
