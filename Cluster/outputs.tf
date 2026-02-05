output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnets" {
  value = concat(
    aws_subnet.presentation_1[*].id,
    aws_subnet.presentation_2[*].id
  )
}

output "public_subnets" {
  value = concat(
    aws_subnet.public_1[*].id,
    aws_subnet.public_2[*].id
  )
}


output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}
