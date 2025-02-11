

Terraform AWS EC2 with Docker

This Terraform module provisions an AWS EC2 t3.micro instance with Ubuntu 22.04 and installs Docker.

Usage
```


provider "aws" {
  region = "us-east-1"
}

module "security_group" {
  source = "simrettesfu/docker-instance/aws"


}

```
