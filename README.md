# Terraform AWS Cloud Architecture with ECS cluster of EC2 instances

## How to set up the infrastracture

1. Initialize terraform

```
   cd terraform

   terraform init
```

2. Go to AWS console, create new ECR (Elastic Container Registry) 
repository and push the docker image there.

3. Build terraform infrastructure

```
   terraform apply
```

## How to destroy the infrastructure

Run the following command:

```
   terraform destroy
```
