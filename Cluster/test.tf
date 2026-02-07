locals {
  azure_devops_role_arn = "arn:aws:iam::251251171133:role/AzureAgent"
}

resource "aws_eks_access_entry" "azure_pipeline" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = local.azure_devops_role_arn
  type          = "STANDARD"

  depends_on = [
    aws_eks_cluster.this
  ]
}

resource "aws_eks_access_policy_association" "azure_pipeline_admin" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = local.azure_devops_role_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.azure_pipeline
  ]
}


resource "aws_eks_access_entry" "nodes" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = aws_iam_role.node_role.arn
  type          = "EC2_LINUX"

  depends_on = [
    aws_eks_cluster.this
  ]
}
