variable "nginx_namespace" {
  type    = string
  default = "ingress-nginx"
}

variable "replica_count" {
  type    = number
  default = 2
}

variable "service_type" {
  type    = string
  default = "LoadBalancer"
}

variable "aws_lb_type" {
  type    = string
  default = "nlb"
}

variable "aws_lb_internal" {
  type    = bool
  default = false
}