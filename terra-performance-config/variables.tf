variable "app_name" {
  default = "nginx-node-redis-demo"
}

variable "env_name" {
  default = "demo-env"
}

variable "region" {
  type        = string
  default     = "us-east-1"
}


variable "description" {
  default = "Node Counter App to illustrate the power of Terraform"
}

variable "instance_type" {
  default = "t4g.micro"  # ARM64 Graviton, if using AMD64, change it to t3.micro or small
}