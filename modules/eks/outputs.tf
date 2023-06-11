
output "eks_security_group" {
  value = aws_security_group.eks_sg.id
}

output "eks_ca" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_sg" {
  value = aws_security_group.eks_sg.id
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "workers_role_arn" {
  value = aws_iam_role.workers_role.arn
}

output "workers_sg" {
  value = aws_security_group.workers_sg.id
}