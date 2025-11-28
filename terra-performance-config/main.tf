data "aws_vpc" "default" { 
    default = true 
    }

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]
  }
}

resource "aws_s3_object" "dockerrun" {
  bucket       = "pravesh-ebs-terra-performance-bucket"
  key          = "eb-demo/Dockerrun.aws.json"
  source       = "Dockerrun.aws.json"
  content_type = "application/json"
}

resource "aws_elastic_beanstalk_application_version" "v1" {
  name        = "v1-arm64-docker"
  application = module.elastic-beanstalk-application.elastic_beanstalk_application_name
  bucket      = aws_s3_object.dockerrun.bucket
  key         = aws_s3_object.dockerrun.key
}

module "elastic-beanstalk-application" {
  source  = "cloudposse/elastic-beanstalk-application/aws"
  version = "0.12.1"
  name = var.app_name
}

module "elastic-beanstalk-environment" {
  source  = "cloudposse/elastic-beanstalk-environment/aws"
  version = "0.53.0"

    name                                = "${var.app_name}-env"
    description                         = var.description
    region                              = var.region
    elastic_beanstalk_application_name  = module.elastic-beanstalk-application.elastic_beanstalk_application_name
    environment_type                    = "SingleInstance"
    rolling_update_enabled              = "false"       
    instance_type                       = var.instance_type
    version_label                       = aws_elastic_beanstalk_application_version.v1.name
    vpc_id                              = data.aws_vpc.default.id
    application_subnets                 = data.aws_subnets.default.ids
    solution_stack_name                 = "64bit Amazon Linux 2023 v4.3.0 running ECS" 
}