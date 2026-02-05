variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_id" {
  type = string
}

variable "nlb_arn" {
  type = string
}


variable "project_name" {
  type    = string
  default = "nti"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "nlb_dns" {
  type = string
  description = "DNS of the Network Load Balancer created by Ingress"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the VPC Link"
}
