provider "aws" {
  region = "us-east-1"
}



data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "ingress-nginx"
  }
}


data "aws_eks_cluster" "cluster" {
  name = "nti-nonprod-eks"
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}