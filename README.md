# IAC deploy home task  APP in AWS with terraform and Jenkins

## Whats this ?

This is an implementation of the classic two tier architecture for application hosting deployed with terraform and jenkins in AWS.  <br />
two  modules that constructs our architecture:
* [web] --> web Application server
* [db] --> Mysql AWS RDS 

## Technologies
AWS : Cloud provider for hosting
Terraform: Automation of creation infrastructure on AWS
Jenkins: for automatic deployments(CI/CD).
Python: Example web application. 
inspec: for provisioning testing

## How to deploy

Setup:
* [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)
* Setup your credentials via [AWS Provider](https://www.terraform.io/docs/providers/aws/index.html#access_key)
* Clone this project


## Main terraform module inputs

| Name                  | Description                                           | Type   | Default | Required |
| ------                | -------------                                         | :----: | :-----: | :-----:  |
| infra_name            | Naming conventions for infra                          | string | -       | yes      |
| aws_region            | AWS region where you have to put your infra           | string | -       | yes      |
| ec2_amis              | AMI used for creating ec2 instances                   | string | -       | yes      |
| vpc_cidr              | The cidr range for vpc                                | string | -       | yes      |
| db_subnets_cidr       | The cidr range for db				                    | string | -       | yes      |
| private_subnet_cidr   | The cidr range for private subnet                     | string | -       | yes      |
| public_subnet_cidr    | The cidr range for public subnet                      | string | -       | yes      |
| key_name              | Unique name for the keypair                           | string | -       | yes      |
| path                  | Path to a directory where key will be stored.         | string | -       | yes      |
| aws_creds_path        | path of aws creds                                     | string | -       | yes      |
| rds_storage           | RDS storage space                                     | string | -       | yes      |
| rds_engine            | RDS engine type                                       | string | -       | yes      |
| rds_instance_class    | RDS instance class                                    | string | -       | yes      |
| rds_name              | Name of the RDS                                       | string | -       | yes      |
| rds_username          | Username of the RDS                                   | string | -       | yes      |
| rds_password          | Password of the RDS                                   | string | -       | yes      |
| db_port               | The port on which the DB accepts connections          | string | -       | yes      |

## Outputs

| Name         | Description                         |
| ------       | -------------                       |
| app_elb_url  | backend app server loadbalancer url |
| Domain_Url   | Domain url for web application      |
| rds_endpoint | RDS endpoint                        |

## Command Line to test locally
To setup provisioner
```
https://github.com/Abdessamii85/Helloworld-deploy-with-terraform.git
cd Helloworld-deploy-with-terraform/terraform
$ terraform init
```

plan the launch the application 
```
$ terraform plan -out=aws.tfplan
```
or with custom variable in tf.vars file
```
$ terraform plan -out=aws.tfplan -var-file=tf.vars
```
apply the launch in aws:
```
$ terraform apply aws.tfplan
```
To teardown the infrastructure :
```
$ terraform destroy
```

## Pipeline Prerequisites
The slave Jenkins needs to have the following  :
-  [Terraform](https://www.terraform.io/intro/getting-started/install.html) 
-  [inspec](https://downloads.chef.io/tools/inspec)

## Provisioning testing with inspec

we can run test against the infrastructure after ther terraform apply command with [inspec](https://github.com/inspec/inspec)

