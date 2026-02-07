resource "aws_iam_role" "eks_cluster_role" {
  name = "${local.name_prefix}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action   = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# resource "aws_eks_cluster" "this" {
#   name     = local.cluster_name
#   role_arn = aws_iam_role.eks_cluster_role.arn
# 
#   vpc_config {
#     subnet_ids = [
#       aws_subnet.presentation_1.id,
#       aws_subnet.presentation_2.id
#     ]
#   }
#   depends_on = [
#     aws_iam_role_policy_attachment.eks_cluster_policy
#   ]
# }

resource "aws_eks_cluster" "this" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    subnet_ids = [
      aws_subnet.presentation_1.id,
      aws_subnet.presentation_2.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

# انتظار الكلاستر يبقى ACTIVE قبل إنشاء الـ Node Group (عشان الـ nodes تظهر)
resource "null_resource" "wait_for_cluster" {
  depends_on = [aws_eks_cluster.this]

  provisioner "local-exec" {
    command = "aws eks wait cluster-active --name ${aws_eks_cluster.this.name} --region ${data.aws_region.current.name}"
  }

  triggers = {
    cluster_name = aws_eks_cluster.this.name
  }
}