resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.nginx_namespace
  create_namespace = true

  set {
    name  = "controller.replicaCount"
    value = var.replica_count
  }

  set {
    name  = "controller.service.type"
    value = var.service_type
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = var.aws_lb_type
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal"
    value = tostring(var.aws_lb_internal)
  }
}