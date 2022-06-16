# Purpose:

Create S3 bucket, DyanmoDB table and setup .tfstate remote backend

> !! This module should be applied before setting up .tfstate remote backend on S3 !!

## Variable Inputs:

- namespace   (project name);
- environment (ex: dev/prod);

## Resources created:

1. S3 bucket;
    - server_side_encryption_configuration = enabled,
    - prevent_destroy = true,
    - acl = private,
    - versioning = enabled.

2. DynamoDB table;

## Resources naming convention:

- Bucket name: 

  i. with envronment:
     "${var.namespace}-${var.environment}-tfstate"
      ex: studiographene-dev-tfstate

  ii. without environment:
      "${var.namespace}-tfstate"
      ex: studiographene-tfstate

- DynamoDB table name:

  i. with envronment:
     "${var.namespace}-${var.environment}-tfstate-lock"
      ex: studiographene-dev-tfstate-lock

  ii. without environment:
      "${var.namespace}-tfstate-lock"
      ex: studiographene-tfstate-lock

---

# Setting up .tfstate remote backend on S3.

1. Call the S3 bucket, DynamoDB table creating module from your tf code.
    (best: create a file named "remote-bucket.tf", and call from there)
2. Specifying Variable Inputs along the module call.

Example:

```
provider "aws" {
  region = "us-east-1"
}

module "remote_tfstate_bucket" {
source = "git@github.com:studiographene/tf-modules.git//tfstate-s3-backend"
namespace   = "sg"
environment = "dev"
}
```

3. From terminal: 

```
terraform init 
```
```
terraform plan
```
```
terraform apply
```

4. Place and keep the below code in your infra. tf code directory
   (best: create "backend.tf", and add the below code in, fill the data)

```
terraform {
backend "s3" {
bucket = module.remote_tfstate_bucket.tfstate_bucket_name
key = "/terrform.tfstate"
region = var.main_region
dynamodb_table = module.remote_tfstate_bucket.dynamodb_table_name
encrypt = true
}
}
```

Data to fill:
(refer "Resources naming convention" for help)

- bucket: Name of the bucket created. (ex: bucket = "sg-tfstate").

- key: add the enviroment as a folder to contain "terraform.tfstate" file.
  "key" is the .tfstate file directory in the bucket.
  (ex: if enviroment = "test", fill the key as: "test/terrform.tfstate" including the file name).
  folder name/path, .tfstate file name, can be specified as per the project standard.

- dynamodb_table: Name of the DynamoDB table created. (ex: "sg-test-tfstate-lock").
- region: Bucket region. (ex: us-east-1).

Example:

```
terraform {
backend "s3" {
bucket = "sg-infra"
key = "test/terrform.tfstate"
region = "us-east-1"
dynamodb_table = "test-state-lock"
encrypt = true
}
}
```

5. Initiating remote backend.

``` 
terraform init
```
6. Applying remote backend.

```
terraform apply
```

!! You have successfully setup remote S3 backend for .tfstate !!

